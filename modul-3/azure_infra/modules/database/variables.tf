variable "saname" {
  type = string
  description = "The name of storage account"
  default = "matserntdemo"
}

variable "mssqlname" {
  description = "The name of the SQL database"
  type = string
  default = "mssql001"
}

variable "mssqldbname" {
  description = "The name of the SQL database"
  type = string
  default = "mssqldb001"
}

variable "rgname" {
  description = "The name of the resource group"
  type = string
  default = "rg-tf-demo"
}

variable "location" {
  description = "The location of the resource group"
  type = string
  default = "westeuope"
}

variable "admin_password" {
  type = string
  description = "The password of the admin"
}