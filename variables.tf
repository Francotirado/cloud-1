variable "cloud_id" {
  type        = string
  default = "b1g4f6ant2gm5tj9gtnq"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default = "b1gi750rb0rc8mjglafr"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = list(string)
  default     = ["ru-central1-a"]
}

variable "vpc_name" {
  type        = string
  default     = "network"
  description = "VPC network name"
}

variable "vpc_public_name" {
  type        = string
  default     = "public"
  description = "VPC public subnet name"
}

variable "vpc_private_name" {
  type        = string 
  default     = "private"
  description = "VPC private subnet name"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "any_ip" {
  type        = string
  default     = "0.0.0.0/0"
}

variable "vm_nat_ip_addr" {
  type        = string 
  default     = "192.168.10.254"
}

variable "vm_nat_name" {
  type        = string
  default     = "netology-nat-vm"
  description = "web vm name"
}

variable "vm_nat_image_id" {
  type = string
  default = "fd80mrhj8fl2oe87o4e1"
}

variable "vm_public_name" {
  type        = string
  default     = "netology-public-mv"
  description = "public vm name"
}

variable "vm_private_name" {
  type        = string
  default     = "netology-private-vm"
  description = "private vm name"
}

variable "image_name" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "username" {
  type = string
  default = "ubuntu"
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/yc-vm-1.pub"
}

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))
  default = {
    web = {
      cores = 2
      memory = 1
      core_fraction = 20
    }
  }
}

variable "vms_meta" {
  type = map(object({
    serial-port-enable = number
    ssh-keys = string
  }))  
  default = {
    data = {
    serial-port-enable = 1
      ssh-keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2Tcn3s8D1RoPl/2aRs9VNvL03KVw26pXhRM2b+3DXx per@192.168.1.3"
    }
  }
}

variable "vms_platform_id" {
  type = string
  default = "standard-v3"
}
