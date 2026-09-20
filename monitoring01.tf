module "monitoring01" {
  source = "./modules/proxmox_vm"

  vm_name             = "monitoring01"
  vm_id               = 512
  target_node         = "pve02" # matches template_node: avoids migrating the fresh clone off pve02, whose storage_pool (holds the template's cloud-init disk) is the only node it still exists on since pve01's reimage
  template_vm_id      = 101
  template_node       = "pve02" # current template location; safe to keep updated now that the module ignores clone changes post-creation
  cores               = 2
  memory              = 4096
  disk_size           = 32 # template floor, OS + packages only
  disk_datastore      = "vm_storage"
  data_disk_size      = 30 # Prometheus + Loki + Grafana data, kept off the OS disk so an OS rebuild doesn't wipe log/metric history
  data_disk_datastore = "vm_storage"
  network_bridge      = "servers"
  ip_address          = "10.13.0.20/24"
  gateway             = "10.13.0.1"
  ssh_public_keys     = var.ssh_public_keys

  notes = <<-EOT
    Prometheus + Loki + Grafana (dedicated instance, not the one on
    pve-docker-int01). Data disk (scsi1) mounted at /data on the VM, kept
    local (not NFS/CephFS) since Prometheus/Loki's small random writes
    (WAL, chunk index, locking) handle network filesystems badly, and this
    host must stay independent of the NFS gateway it also monitors.

    Deployed by Terraform (this file) + Ansible role `monitoring_server`
    (partitions/mounts /data) + `monitoring_agent` (Alloy, on this VM too)
    + Komodo, pulling the `monitoring` stack from the compose repo.
  EOT
}

output "monitoring01_ip" {
  value = module.monitoring01.ipv4_address
}
