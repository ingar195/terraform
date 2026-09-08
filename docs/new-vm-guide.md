# Creating a New VM — Quick Guide

## 1. Copy an existing `.tf` file as your starting point

Pick any existing one (`nfs_gateway.tf` is a good simple example) and copy it
to a new file named after the service, e.g. `nginx-proxy-manager.tf`.

## 2. Fill in these fields

```hcl
module "REPLACE_ME" {                # unique name, e.g. "nginx_proxy_manager"
  source = "./modules/proxmox_vm"

  vm_name         = "REPLACE_ME"      # e.g. "npm01" — shows up in Proxmox
  vm_id           = REPLACE_ME        # pick an unused VMID (check Proxmox UI)
  target_node     = "REPLACE_ME"      # which Proxmox node it should run on: pve01 / pve02 / pve03
  template_vm_id  = 101
  template_node   = "pve02"           # current template location — don't change after creation (see terraform-foundation.md plan doc)
  disk_datastore  = "vm_storage"
  network_bridge  = "REPLACE_ME"      # "vmbr0" for internal, "dmz" if internet-facing/DMZ
  ip_address      = "REPLACE_ME/24"   # e.g. "10.11.0.54/24" — pick an unused IP
  gateway         = "REPLACE_ME"      # "10.11.0.1" for the vmbr0 segment, "10.12.0.1" for dmz
  ssh_public_keys = var.ssh_public_keys
}

output "REPLACE_ME_ip" {              # match the module name above
  value = module.REPLACE_ME.ipv4_address
}
```

**Everything else is optional** — the module already defaults to sane values
(2 cores, 2GB RAM, 32GB disk, `x86-64-v2-AES` CPU, DNS = gateway). Only add
`cores`, `memory`, `disk_size`, or `cpu_type` if this VM genuinely needs
something different.

## 3. Apply it

Run these from the **root of this repo** (`C:\Users\ingar\Documents\workspace\terraform`) — every `.tf` file there is one combined configuration, you don't `cd` into a specific file.

```powershell
$env:TF_VAR_proxmox_api_token = (Get-Content "C:\Users\ingar\Documents\workspace\terraform\.pve_api" -Raw).Trim()
$creds = Get-Content "C:\Users\ingar\Documents\workspace\terraform\.minio_credentials"
foreach ($line in $creds) {
    $parts = $line -split '=', 2
    Set-Item -Path "env:$($parts[0])" -Value $parts[1]
}
terraform init
terraform plan     # check it shows exactly "1 to add" for your new VM, nothing else touched
terraform apply    # type yes
```

**To apply just your new VM and leave any other pending changes untouched**, target it by its module name (the name you gave the `module "..."` block, e.g. `nginx_proxy_manager`):

```powershell
terraform plan -target=module.nginx_proxy_manager
terraform apply -target=module.nginx_proxy_manager
```

Only reach for `-target` when you specifically want to isolate one change like this — a plain `terraform plan`/`apply` (no target) already only shows real pending changes, so `-target` isn't needed day-to-day, just when you've got more than one new thing defined and want to apply them one at a time.

## 4. Add it to Ansible

In the **ansible repo** (`D:\Workspace\ansible`):

1. Add a new group + IP to `hosts.ini` (and mirror it with a placeholder IP in `inventory_public`).
2. Write (or reuse) a role for the service under `roles/`.
3. Add a play for it in `site.yml`.
4. Verify SSH first: `ssh user@<new-ip> "hostname && whoami"`.
5. Run it: `ansible-playbook -i hosts.ini site.yml --limit <group-name>`.

## Things to double-check before applying

- **VMID and IP aren't already in use** — check the Proxmox UI's Server View tree.
- **`network_bridge`/`gateway` match the trust tier this service belongs in** — internal (`vmbr0`, `10.11.0.1`) vs DMZ (`dmz`, `10.12.0.1`). Don't mix these up for anything internet-facing.
- **Never change `template_node`/`template_vm_id` on an already-applied resource** — that block is create-time only; see the "clone.node_name is create-time-only" note in `docs/superpowers/plans/2026-09-06-terraform-foundation.md` in the ansible repo for why.
