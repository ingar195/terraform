module "nfs_gateway" {
  source = "./modules/proxmox_vm"

  vm_name         = "nfs-gw01"
  vm_id           = 511
  target_node     = "pve01"
  template_vm_id  = 101
  template_node   = "pve02" # current template location; safe to keep updated now that the module ignores clone changes post-creation
  disk_datastore  = "vm_storage"
  network_bridge  = "vmbr0"
  ip_address      = "10.11.0.53/24"
  gateway         = "10.11.0.1"
  ssh_public_keys = var.ssh_public_keys

  notes = <<-EOT
    NFS-Ganesha gateway exposing CephFS `shared-data` to hosts that can't
    mount CephFS natively (Docker via NFS volume driver). Gives Komodo
    containers shared, off-VM persistent storage.

    Deployed by Terraform (this file) + Ansible role `nfs_gateway`.
  EOT
}

output "nfs_gateway_ip" {
  value = module.nfs_gateway.ipv4_address
}
