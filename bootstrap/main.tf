module "minio_vm" {
  source = "../modules/proxmox_vm"

  vm_name         = "tf-state01"
  vm_id           = 510
  target_node     = "pve01"
  template_vm_id  = 101
  template_node   = "pve02" # current template location; safe to keep updated now that the module ignores clone changes post-creation
  disk_datastore  = "vm_storage"
  network_bridge  = "vmbr0"
  ip_address      = var.minio_vm_ip_address
  gateway         = var.minio_vm_gateway
  ssh_public_keys = var.ssh_public_keys

  notes = <<-EOT
    MinIO VM providing the S3-compatible Terraform remote state backend
    (bucket `tf-state`) for the fleet's Terraform config.

    Deployed by Terraform (this file).
  EOT
}

output "minio_vm_ip" {
  value = module.minio_vm.ipv4_address
}
