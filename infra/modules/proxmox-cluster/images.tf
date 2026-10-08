resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.proxmox_node_name

  url                = var.ubuntu_cloud_image_url
  file_name          = local.ubuntu_cloud_image_file_name
  checksum           = var.ubuntu_cloud_image_checksum
  checksum_algorithm = "sha256"
  overwrite          = true
}
