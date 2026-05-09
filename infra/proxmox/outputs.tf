output "proxmox_version" {
  description = "Proxmox VE version reported by the API."
  value       = data.proxmox_version.current
}

output "proxmox_node_names" {
  description = "Proxmox node names visible to the Terraform API token."
  value       = data.proxmox_virtual_environment_nodes.available.names
}

output "proxmox_nodes_online" {
  description = "Online status for Proxmox nodes visible to the Terraform API token."
  value       = data.proxmox_virtual_environment_nodes.available.online
}

output "ubuntu_cloud_image_file_id" {
  description = "Downloaded Ubuntu cloud image file ID in Proxmox."
  value       = proxmox_download_file.ubuntu_cloud_image.id
}

output "ubuntu_template_vm_id" {
  description = "VMID of the Ubuntu cloud-init template."
  value       = proxmox_virtual_environment_vm.ubuntu_template.vm_id
}

output "kubernetes_node_reservations" {
  description = "DHCP reservation map for Kubernetes nodes."
  value = {
    for name, node in var.kubernetes_nodes : name => {
      vm_id       = node.vm_id
      mac_address = node.mac_address
      reserved_ip = node.reserved_ip
      role        = node.role
    }
  }
}

output "kubernetes_node_vm_ids" {
  description = "VMIDs of Kubernetes node VMs."
  value = {
    for name, vm in proxmox_virtual_environment_vm.kubernetes_nodes : name => vm.vm_id
  }
}
