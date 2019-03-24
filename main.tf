# Render install script
######################################################################
data "template_file" "helm-install-script" {
  template = "${file("${path.module}/scripts/helm_install_vars.sh")}"

  vars {
    kubeconfig     = "${var.kubeconfig}"
    name           = "${var.name}"
    tiller_version = "${var.tiller_version}"

    # Use a separate file for bash script
    logic = "${file("${path.module}/scripts/helm_install_logic.sh")}"
  }
}

# Render Destroy script
######################################################################
data "template_file" "helm-destroy-script" {
  template = "${file("${path.module}/scripts/helm_destroy.sh")}"

  vars {
    kubeconfig = "${var.kubeconfig}"
    name       = "${var.name}"
  }
}

# Install Helm
######################################################################
resource "null_resource" "helm-install" {
  count = "${var.enabled}"

  triggers = {
    # Trigger deployment on script changes (destroy script does not need to trigger new deployment)
    vars_change  = "${sha1(file("${path.module}/scripts/helm_install_vars.sh"))}"
    logic_change = "${sha1(file("${path.module}/scripts/helm_install_logic.sh"))}"
  }

  provisioner "local-exec" {
    command     = "${data.template_file.helm-install-script.rendered}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

# Uninstall Helm
######################################################################
resource "null_resource" "helm-destroy" {
  count = "${var.enabled ? 0 : 1 }"

  provisioner "local-exec" {
    command     = "${data.template_file.helm-destroy-script.rendered}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}
