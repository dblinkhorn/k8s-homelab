output "proxmox_version" {
  description = "Proxmox VE version reported by the API."
  value       = data.proxmox_version.current
}

output "proxmox_nodes" {
  description = "Proxmox nodes visible to the Terraform API token."
  value       = data.proxmox_virtual_environment_nodes.available
}

output "ubuntu_cloud_image_file_id" {
  description = "Downloaded Ubuntu cloud image file ID in Proxmox."
  value       = proxmox_download_file.ubuntu_cloud_image.id
}

output "ubuntu_template_vm_id" {
  description = "VMID of the Ubuntu cloud-init template."
  value       = proxmox_virtual_environment_vm.ubuntu_template.vm_id
}
