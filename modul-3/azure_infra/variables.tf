variable "rgname" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-tf-demo"
}

variable "location" {
  description = "The locationg of the resource group"
  type        = string
  default     = "westeurope"
}

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
  type        = string
  default     = "subnet-tf-demo"
}

variable "saname" {
  type        = string
  description = "The name of storage account"
  default     = "matserntdemo"
}

variable "mssqlname" {
  description = "The name of the SQL database"
  type        = string
  default     = "mssql001"
}

variable "mssqldbname" {
  description = "The name of the SQL database"
  type        = string
  default     = "mssqldb001"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "ID-en til subnet-et VM-ene skal kobles på"
}

variable "vmssname" {
  description = "The name of the virtual maching scale set"
  type        = string
  default     = "vmss-tf-demo"
}