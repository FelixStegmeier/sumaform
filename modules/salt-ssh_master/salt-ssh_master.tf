resource "terraform_data" "provisioning" {

  connection {
    host     = "apprentice-controller.mgr.suse.de" #!!!!!!!!!!!!
    user     = "root"
    password = "linux"
    // ssh connection through a bastion host
    bastion_host        = lookup(var.provider_settings, "bastion_host", var.base_configuration["bastion_host"])
    bastion_host_key    = lookup(var.provider_settings, "bastion_host_key", var.base_configuration["bastion_host_key"])
    bastion_port        = lookup(var.provider_settings, "bastion_port", var.base_configuration["bastion_port"])
    bastion_user        = lookup(var.provider_settings, "bastion_user", var.base_configuration["bastion_user"])
    bastion_password    = lookup(var.provider_settings, "bastion_password", var.base_configuration["bastion_password"])
    bastion_private_key = lookup(var.provider_settings, "bastion_private_key", var.base_configuration["bastion_private_key"])
    bastion_certificate = lookup(var.provider_settings, "bastion_certificate", var.base_configuration["bastion_certificate"])
  }

  provisioner "file" {
    source      = "salt"
    destination = "/root"
  }

  provisioner "file" {
    content = var.salt-ssh_data
    destination = "/tmp/salt-ssh_data"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "bash /root/salt/wait_for_salt.sh",
  #   ]
  # }
}

output "salt-ssh_data" {
  value = var.salt-ssh_data
}