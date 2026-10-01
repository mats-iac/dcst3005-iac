variable "subnet_id" {
  type        = string
  default     = ""
  description = "ID-en til subnet-et VM-ene skal kobles på"
}

variable "vmssname" {
  description = "The name of the virtual maching scale set"
  type = string
  default = "vmss-tf-demo"
}

variable "rgname" {
  description = "The name of the resource group"
  type = string
  default = "rg-tf-demo"
}

variable "location" {
  description = "The location of the resource group"
  type = string
  default = "westeurope"
}

variable "admin_password" {
  type = string
  description = "The password of the admin"
}