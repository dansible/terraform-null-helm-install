# K8s Helm Install

This Terraform module installs Helm on a K8s cluster.

- [Usage](#usage)
- [Variables](#variables)
- [Dependencies](#dependencies)
- [Links](#links)

## Usage

```hcl
module "helm" {
  source     = "git@github.com:dansible/terraform-null-helm-install.git?ref=v0.0.2"
  kubeconfig  = "${module.k8s.kubeconfig}"  # This is assumed to be the output of the GKE module but can be any Kubeconfig
  enabled    = true
  depends_on = "${module.pre-install}" # This can be any TF resource
}
```

## Variables

For more info, please see the [variables file](variables.tf).

| Variable               | Description                         | Default                                               |
| :--------------------- | :---------------------------------- | :---------------------------------------------------- |
| `kubeconfig` | Kubeconfig for cluster in which Helm will be installed. | `(Required)` |
| `name` | Temporary name to assign to kubeconfig. | `tmp` |
| `tiller_version` | Version of Tiller component. Must match the Helm cli on the machine executing Terraform. | `v2.12.3` |
| `enabled` | Whether to enable this module. Set to `false` to properly uninstall Helm. | `true` |

## Dependencies

This module exposes two variables to work around the limitations of modules in Terraform.

| Name               | Type                         | Description                                     |
| :----------------- | :--------------------------- | :---------------------------------------------- |
| `depends_on` | `list variable` | Dummy variable to enable module dependencies. |
| `dependency` | `list output` | Dummy output to enable module dependencies. |

Using these two, you can emulate the functionality of `depends_on` by chaining one module's output to another's `depends_on` input.

## Links

- https://github.com/hashicorp/terraform/issues/15933
- https://www.terraform.io/docs/providers/template/
- https://www.terraform.io/docs/configuration/interpolation.html#templates