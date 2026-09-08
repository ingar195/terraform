module "komodo_manager" {
  source = "./modules/proxmox_vm"

  vm_name         = "pve-mgr01"
  vm_id           = 201
  target_node     = "pve02"
  template_vm_id  = 101
  template_node   = "pve02" # current template location; safe to keep updated now that the module ignores clone changes post-creation
  cpu_type        = "x86-64-v3"
  disk_datastore  = "vm_storage"
  network_bridge  = "vmbr0"
  ip_address      = "10.11.0.51/24"
  gateway         = "10.11.0.1"
  ssh_public_keys = var.ssh_public_keys

  notes = <<-EOT
    Runs Komodo, the Docker Compose orchestrator for the homelab. Mongo
    data lives on NFS (nfs-gw01, export `/komodo-manager`), not local
    disk, so this VM is fully disposable.

    Deployed by Terraform (this file) + Ansible role `komodo`.
  EOT
}

output "komodo_manager_ip" {
  value = module.komodo_manager.ipv4_address
}
