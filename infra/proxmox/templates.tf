resource "proxmox_virtual_environment_vm" "node_template" {
  vm_id     = var.template_vm_id
  name      = var.template_name
  node_name = var.proxmox_node_name

  description = var.template_description
  tags        = ["cloudinit", "template", "terraform", "ubuntu"]

  template = true
  started  = false
  on_boot  = false

  machine = "q35"
  bios    = "ovmf"

  tablet_device = false

  agent {
    enabled = false
  }

  cpu {
    cores = var.template_cpu_cores
    type  = var.vm_cpu_type
  }

  memory {
    dedicated = var.template_memory_mb
    floating  = var.template_memory_mb
  }

  efi_disk {
    datastore_id = var.vm_datastore_id
    type         = "4m"
  }

  disk {
    datastore_id = var.vm_datastore_id
    import_from  = proxmox_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = var.template_disk_size_gb
  }

  initialization {
    datastore_id = var.vm_datastore_id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  stop_on_destroy = true
}
