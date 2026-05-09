resource "proxmox_virtual_environment_vm" "kubernetes_nodes" {
  for_each = var.kubernetes_nodes

  vm_id     = each.value.vm_id
  name      = each.key
  node_name = var.proxmox_node_name

  description = "${each.value.role} Kubernetes node managed by Terraform."
  tags        = ["kubernetes", each.value.role, "terraform", "ubuntu"]

  started = true
  on_boot = true

  machine       = "q35"
  bios          = "ovmf"
  scsi_hardware = "virtio-scsi-single"
  tablet_device = false

  clone {
    vm_id        = proxmox_virtual_environment_vm.ubuntu_template.vm_id
    node_name    = var.proxmox_node_name
    datastore_id = var.vm_datastore_id
    full         = true
  }

  agent {
    enabled = false
  }

  cpu {
    cores = each.value.cpu_cores
    type  = var.template_cpu_type
  }

  memory {
    dedicated = each.value.memory_mb
    floating  = each.value.memory_mb
  }

  efi_disk {
    datastore_id = var.vm_datastore_id
    type         = "4m"
  }

  disk {
    datastore_id = var.vm_datastore_id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = each.value.disk_size_gb
  }

  initialization {
    datastore_id = var.vm_datastore_id

    user_account {
      username = var.vm_username
      keys     = [trimspace(file(pathexpand(var.ssh_public_key_path)))]
    }

    dns {
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge      = var.network_bridge
    model       = "virtio"
    mac_address = each.value.mac_address
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  stop_on_destroy = true
}
