// Description : Creating a virtual machine template under Rocky Linux 10 from ISO file with Packer using VMware Workstation
// Author : Yoann LAMY <https://github.com/ynlamy/packer-rockylinux10>
// Licence : GPLv3

// Packer : https://developer.hashicorp.com/packer/

packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

variable "iso" {
  type        = string
  description = "A URL to the ISO file"
  default     = "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.1-x86_64-minimal.iso"
}

variable "checksum" {
  type        = string
  description = "The checksum for the ISO file"
  default     = "sha256:5aafc2c86e606428cd7c5802b0d28c220f34c181a57eefff2cc6f65214714499"
}

variable "headless" {
  type        = bool
  description = "When this value is set to true, the machine will start without a console"
  default     = true
}

variable "name" {
  type        = string
  description = "This is the name of the new virtual machine"
  default     = "vm-rockylinux10"
}

variable "username" {
  type        = string
  description = "The username to connect to SSH"
  default     = "root"
}

variable "password" {
  type        = string
  description = "A plaintext password to authenticate with SSH"
  default     = "MotDePasse"
}

source "vmware-iso" "rockylinux10" {
  // Documentation : https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/iso

  // ISO configuration
  iso_url      = var.iso
  iso_checksum = var.checksum

  // Driver configuration
  cleanup_remote_cache = false

  // Hardware configuration
  vm_name           = var.name
  vmdk_name         = var.name
  version           = "21"
  guest_os_type     = "rockylinux-64"
  cpus              = 1
  vmx_data = {
    "numvcpus" = "2"
  }
  memory            = 2048
  disk_size         = 30720
  disk_adapter_type = "scsi"
  disk_type_id      = "1"
  network           = "nat"
  sound             = false
  usb               = false

  // Run configuration
  headless = var.headless

  // Shutdown configuration
  shutdown_command = "systemctl poweroff"

  // Http directory configuration
  http_directory = "http"

  // Boot configuration
  boot_command = ["<up>e<wait><down><down><end> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<f10>"]
  boot_wait    = "10s"

  // Communicator configuration
  communicator = "ssh"
  ssh_username = var.username
  ssh_password = var.password
  ssh_timeout  = "30m"

  // Output configuration
  output_directory = "template"

  // Export configuration
  format          = "vmx"
  skip_compaction = false
}

build {
  sources = ["source.vmware-iso.rockylinux10"]

  provisioner "shell" {
    scripts = [
      "scripts/provisioning.sh"
    ]
  }

}
