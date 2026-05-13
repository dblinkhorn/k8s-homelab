variable "proxmox_endpoint" {
  type        = string
  description = "Do not include /api2/json."
}

variable "proxmox_api_token" {
  type        = string
  description = "Format: user@realm!token-name=token-secret."
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
  description = "Datastore for cloud images."
}

variable "vm_datastore_id" {
  type        = string
  description = "Datastore for VM disks."
}

variable "network_bridge" {
  type        = string
  description = "Bridge attached to VM network devices."
}

variable "vm_username" {
  type        = string
  description = "Linux user created by cloud-init on cloned node VMs."
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key cloud-init should authorize for VM access."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers configured for cloned node VMs."
}

variable "kubernetes_nodes" {
  type = map(object({
    vm_id        = number
    role         = string
    mac_address  = string
    reserved_ip  = string
    cpu_cores    = number
    memory_mb    = number
    disk_size_gb = number
  }))

  description = "Kubernetes node VM definitions."
}

variable "ubuntu_cloud_image_url" {
  type        = string
  description = "URL of the Ubuntu cloud image used for the base template."
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "ubuntu_cloud_image_file_name" {
  type        = string
  description = "File name Proxmox should use for the downloaded Ubuntu cloud image. Ubuntu .img cloud images are qcow2 files, so use a .qcow2 suffix for import."
  default     = "noble-server-cloudimg-amd64.qcow2"
}

variable "template_vm_id" {
  type        = number
  description = "VMID for the node VM template."
}

variable "template_name" {
  type        = string
  description = "Name for the node VM template."
}

variable "template_description" {
  type        = string
  description = "Description for the node VM template."
  default     = "Node VM template managed by Terraform."
}

variable "template_cpu_cores" {
  type        = number
  description = "CPU cores assigned to the template."
  default     = 2
}

variable "vm_cpu_type" {
  type        = string
  description = "CPU model assigned to Proxmox VMs."
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
