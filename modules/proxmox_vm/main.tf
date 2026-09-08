locals {
  effective_dns_servers = length(var.dns_servers) > 0 ? var.dns_servers : [var.gateway]
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  node_name = var.target_node
  vm_id     = var.vm_id

  clone {
    vm_id     = var.template_vm_id
    node_name = var.template_node
    full      = true
  }

  lifecycle {
    # The clone source only matters at creation time. Once a VM exists,
    # Terraform must never re-evaluate this block — doing so either forces
    # an unwanted destroy+recreate (if the value changes) or errors outright
    # (if the historical source VM/node no longer exists).
    ignore_changes = [clone]
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.disk_datastore
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.vlan_id
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    dns {
      servers = local.effective_dns_servers
    }

    user_account {
      username = var.ci_username
      keys     = var.ssh_public_keys
    }
  }
}
