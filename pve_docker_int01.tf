module "pve_docker_int01" {
  source = "./modules/proxmox_vm"

  vm_name         = "pve-docker-int01"
  vm_id           = 204
  target_node     = "pve01"
  template_vm_id  = 101
  template_node   = "pve02" # current template location; safe to keep updated now that the module ignores clone changes post-creation
  cores           = 4
  memory          = 8192
  disk_size       = 32 # was 100G on the old VM; all real data now lives on CephFS via NFS, so the standard template size is enough
  disk_datastore  = "vm_storage"
  network_bridge  = "servers"
  mac_address     = "BC:24:11:52:FD:13" # pinned to the old pve-docker02's MAC -- this network segment has a MAC-keyed rule somewhere (switch/firewall), confirmed by the new VM being completely unreachable (no ARP reply) with a fresh MAC
  ip_address      = "10.13.0.12/24"
  gateway         = "10.13.0.1"
  ssh_public_keys = var.ssh_public_keys

  notes = <<-EOT
    Internal (non-DMZ) Docker host -- runs Home Assistant, Node-RED,
    Grafana, InfluxDB, Mosquitto, ESPHome, zwavejs2mqtt (unused),
    Homarr, Uptime Kuma, Speedtest-tracker, and the Komodo agent.
    Renamed from pve-docker02. Zigbee (ConBee II) reaches this VM via
    USB/IP from mini01, not Proxmox passthrough -- see roles/homeassistant.
    All service data lives on CephFS (nfs-gw01, export `/pve-docker-int01`),
    so this VM is fully disposable.

    Deployed by Terraform (this file) + Ansible roles `docker`, `homeassistant`.
  EOT
}

output "pve_docker_int01_ip" {
  value = module.pve_docker_int01.ipv4_address
}
