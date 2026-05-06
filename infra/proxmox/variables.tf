variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox VE API endpoint. Do not include /api2/json."
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox VE API token in the format user@realm!token-name=token-secret."
  sensitive   = true
}

variable "proxmox_insecure" {
  type        = bool
  description = "Skip TLS verification for Proxmox self-signed certificates."
  default     = true
}

variable "proxmox_node_name" {
  type        = string
  description = "Proxmox node name where images and VMs are managed."
}

variable "image_datastore_id" {
  type        = string
  description = "Proxmox datastore used for downloaded cloud images."
}

variable "vm_datastore_id" {
  type        = string
  description = "Proxmox datastore used for VM disks."
}

variable "network_bridge" {
  type        = string
  description = "Proxmox bridge attached to VM network devices."
}

variable "ubuntu_cloud_image_url" {
  type        = string
  description = "Official Ubuntu cloud image URL used for the base template."
  default     = "https://cloud-images.ubuntu.com/daily/server/resolute/current/resolute-server-cloudimg-amd64.img"
}

variable "ubuntu_cloud_image_file_name" {
  type        = string
  description = "File name Proxmox should use for the downloaded Ubuntu cloud image. Ubuntu .img cloud images are qcow2 files, so use a .qcow2 suffix for import."
  default     = "resolute-server-cloudimg-amd64.qcow2"
}

variable "template_vm_id" {
  type        = number
  description = "VMID for the Ubuntu cloud-init template."
}

variable "template_name" {
  type        = string
  description = "Name for the Ubuntu cloud-init template."
}

variable "template_description" {
  type        = string
  description = "Description for the Ubuntu cloud-init template."
  default     = "Ubuntu cloud-init template managed by Terraform."
}

variable "template_cpu_cores" {
  type        = number
  description = "CPU cores assigned to the template."
  default     = 2
}

variable "template_cpu_type" {
  type        = string
  description = "CPU model assigned to the template."
  default     = "x86-64-v2-AES"
}

variable "template_memory_mb" {
  type        = number
  description = "Memory assigned to the template in MiB."
  default     = 2048
}

variable "template_disk_size_gb" {
  type        = number
  description = "Root disk size assigned to the template in GiB."
  default     = 20
}
