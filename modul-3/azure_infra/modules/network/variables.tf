variable "nsgname" {
  description = "Network security group name"
  type        = string
  default     = "nsg-tf-demo"
}

variable "vnetname" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-tf-demo"
}

variable "subnetname" {
  description = "The name of the subnet"
  type = string
  default = "subnet-tf-demo"
}

variable "rgname" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-tf-demo"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "westeurope"
}

variable "address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
}

variable "subnets" {
  type        = map(string)
  description = "Subnett som skal opprettes: navn => adresseprefiks"

  default = {
    web  = "10.0.1.0/24"
    app  = "10.0.2.0/24"
    data = "10.0.3.0/24"
  }
}
