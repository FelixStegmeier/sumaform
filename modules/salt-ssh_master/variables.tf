variable "base_configuration" {
  description = "use module.base.configuration, see the main.tf example file"
}

variable "provider_settings" {
  description = "Map of provider-specific settings, see the modules/libvirt/README.md"
  default     = {}
}

variable "salt-ssh_data" {
  description = "grains, hostnames and so on for all the salt-ssh minions"
  default     = null
}