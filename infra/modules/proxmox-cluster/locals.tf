locals {
  ubuntu_cloud_image_release_match = try(regex("^.*/release-([0-9]+)/([^/]+)\\.img$", var.ubuntu_cloud_image_url), [])
  ubuntu_cloud_image_default_file_name = length(local.ubuntu_cloud_image_release_match) == 2 ? (
    "${local.ubuntu_cloud_image_release_match[1]}-${local.ubuntu_cloud_image_release_match[0]}.qcow2"
  ) : basename(var.ubuntu_cloud_image_url)
  ubuntu_cloud_image_file_name = coalesce(var.ubuntu_cloud_image_file_name_override, local.ubuntu_cloud_image_default_file_name)
}
