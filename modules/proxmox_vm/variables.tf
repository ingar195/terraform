variable "vm_name" {
  type        = string
  description = "VM name shown in Proxmox"
}

variable "vm_id" {
  type        = number
  description = "Proxmox VMID to assign to the new VM"
}

variable "target_node" {
  type        = string
  description = "Proxmox node the VM will run on"
}

variable "template_vm_id" {
  type        = number
  description = "VMID of the cloud-init template to clone"
}

variable "template_node" {
  type        = string
  description = "Proxmox node the template lives on"
}

variable "cpu_type" {
  type        = string
  default     = "x86-64-v2-AES"
  description = "QEMU CPU type. Defaults away from Proxmox's 'qemu64' baseline, which lacks x86-64-v2 instructions (SSE4.2 etc.) that modern container images' glibc requires."
}

variable "cores" {
  type        = number
  default     = 2
  description = "Number of vCPU cores"
}

variable "memory" {
  type        = number
  default     = 2048
  description = "Memory in MB"
}

variable "disk_size" {
  type        = number
  default     = 32
  description = "Root disk size in GB (template VMID 101 already has a 32GB disk; Proxmox cannot shrink disks on clone, so this must be >= 32)"
}

variable "disk_datastore" {
  type        = string
  default     = "vm_storage"
  description = "Proxmox storage ID backing the VM disk"
}

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Proxmox network bridge"
}

variable "vlan_id" {
  type        = number
  default     = null
  description = "Optional VLAN tag for the network device"
}

variable "mac_address" {
  type        = string
  default     = null
  description = "Optional MAC address to pin on the network device. Terraform clones otherwise get a fresh MAC each time, which silently breaks any external MAC-keyed firewall/switch/DHCP rule even when everything Terraform/Ansible-side is correct. Set this to a previous VM's MAC when recreating it to avoid needing to update those rules manually."
}

variable "ip_address" {
  type        = string
  description = "Static IPv4 address in CIDR form, e.g. 10.11.0.50/24"
}

variable "gateway" {
  type        = string
  description = "Default gateway for the VM's network segment"
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "DNS servers for the VM. Defaults to using the gateway as the resolver (matches this network's setup) when left empty."
}

variable "ci_username" {
  type        = string
  default     = "user"
  description = "Cloud-init user account (must match ansible_user)"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys injected via cloud-init"
}

variable "notes" {
  type        = string
  default     = ""
  description = "Markdown notes shown in the Proxmox UI's VM Notes panel (maps to the VM's description field)"
}
