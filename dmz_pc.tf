module "dmz_pc" {
  source = "./modules/proxmox_vm"

  vm_name         = "pve-docker01"
  vm_id           = 203
  target_node     = "pve01"
  template_vm_id  = 101
  template_node   = "pve02" # current template location; safe to keep updated now that the module ignores clone changes post-creation
  cores           = 2
  memory          = 2048
  disk_size       = 32
  disk_datastore  = "vm_storage"
  network_bridge  = "dmz"
  ip_address      = "10.12.0.11/24"
  gateway         = "10.12.0.1"
  ssh_public_keys = var.ssh_public_keys

  notes = <<-EOT
    DMZ-exposed reverse proxy (nginx-proxy-manager) + Komodo agent.
    Routing rules and cert issuance are code-driven (Ansible role `npm`,
    NPM REST API) rather than data migrated from the old VM -- certs are
    cheap to reissue. Nightly hypervisor-level PBS backup (vm-backup
    datastore) covers disaster recovery; no NFS/CephFS access from this
    host by design (DMZ is excluded from that internal trust tier).

    Deployed by Terraform (this file) + Ansible roles `docker`, `npm`.
  EOT
}

output "dmz_pc_ip" {
  value = module.dmz_pc.ipv4_address
}
