variable "kubeconfig" {
  description = "Kubeconfig for cluster in which Helm will be installed."
}

variable "name" {
  description = "Temporary name to assign to kubeconfig. Defaults to tmp."
  default     = "tmp"
}

variable "tiller_version" {
  description = "Version of Tiller component. Must match the Helm cli on the machine executing Terraform."
  default     = "v2.12.3"
}

variable "enabled" {
  description = "Whether to enable this module. This allows for Helm to be properly uninstalled."
  default     = true
}

######################################################################
variable "depends_on" {
  description = "Dummy variable to enable module dependencies."
  default     = []
  type        = "list"
}

output "dependency" {
  description = "Dummy output to enable module dependencies."
  sensitive   = true
  value       = "${var.name}"
}
