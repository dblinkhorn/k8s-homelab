module "proxmox_cluster" {
  source = "git::https://github.com/dblinkhorn/k8s-homelab.git//infra/modules/proxmox-cluster?ref=<release-tag>"

  proxmox_node_name  = var.proxmox_node_name
  image_datastore_id = var.image_datastore_id
  vm_datastore_id    = var.vm_datastore_id
  network_bridge     = var.network_bridge

  ssh_public_key_path      = var.ssh_public_key_path
  dns_servers              = var.dns_servers
  qemu_guest_agent_enabled = var.qemu_guest_agent_enabled
  kubernetes_nodes         = var.kubernetes_nodes

  template_vm_id = var.template_vm_id
  template_name  = var.template_name
}
