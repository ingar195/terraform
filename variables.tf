variable "proxmox_api_url" {
  type        = string
  default     = "https://10.11.0.11:8006/api2/json"
  description = "Proxmox API endpoint"
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "Proxmox API token in the form user@realm!token-id=secret. Set via TF_VAR_proxmox_api_token, sourced from .pve_api."
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys injected via cloud-init (Windows + WSL, since VMs may be reached from either)"
  default = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC03oa5uu8u6Y6VYVVCb7fRL02AX8yq/doHWIyir1LCr0O7r44y3xNiElRvn8ND1w8zGlT4JAzMvANBJdf1OWeXDZ6/EoWyZB6rZH4VfF8MJgNfdPBP5Xl2Q7I/yxCYeDInml37Ujdyy/kawwfHJIp3Cb5oVT7hTAITevIBjB0mb7HIKgJG1l0bLi5sLZBywPnU9VFJCwK8tkpfAGUPorTMkl/yTLBB49ii5EgNYeCpYe+CQE6/23oiyQ7S9iQqBiVAwTk/+8IyyQJES7vtmgM21IGrltLZmwDfhcyZNjyOVEvHYu5ldUq6IXMiu8s91saAge2cQd7rS7oX030/pdip+M7zdjwrc7kib4G3A2MFsGii3I4sD/RZde5it+302BSU281NQjqHwtEH83y3kk47LB2rYCPyAddN2FZChi0cm+oCHGyp3m1/hPtV6T2D2WDXCGrQFxPE9uaI299iBQk88e+MA2oJHSKLXcbUZXJCZ/1A387Z9hysWaogIJRDoLM= ingar@INGAR-G",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJrO6YY0pCaW4FYOuZCHA64IIwT8R0cUo06jBoislgfsPzz+D1mLz424cRqnVn7JTm1Idhfqhl13K2rxVM7XvDnJN0VV2Jwq18mFT3v0kAkLf1w4te505LvfYTRrVcM0It/MH9qv9/uK1oKZgZcGrluFWoeXEPww19CShMF+2MwJPMPOaB/OQz7pIdjQtJNJ05qZvG67/jwE4L0cb0HOsckQxq3joZCh1kZtk/tuijPGBXd5UmzWxNqm7+2TP0LZ04K7mcLW/HvsAaXU8iuK0svIUnIgN9D6+NzOiUzBvHQz5JHt/KhZmqNDEgbzrxCgFm/bLVg3sG+ZwykiimooBQbrqU+KppVhHGO5W1AnlkvwRH5WX45u+qvbp5DAqPPp7LOK7W8VIJMxTKmLJcxPvfui3CX3wzNtF7gQBFFyxbSzom9tBMw5wZLbAi+AKnk9xrj4xrPq0R4GLa8EY/3zQ25FgGx0zQijXEYDnMcZrBEStfx3UNh4wYhDjsn/Xunes= ingar@INGAR-G",
  ]
}
