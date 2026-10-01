variable "rg_name" {
  type        = string
  description = "Ressursgruppa nettverket skal ligge i. Modulen oppretter den ikke selv."
}

variable "location" {
  type        = string
  description = "Azure-regionen ressursene opprettes i."
}

variable "vnet_name" {
  type        = string
  description = "Navnegrunnlaget miljøet leverer"
}

variable "address_space" {
  type        = string
  description = "Adresserommet vnet-et disponerer, for eksempel 10.0.0.0/16"
}

variable "subnets" {
  type        = map(number)
  description = "Subnettnavn og netnum som skal brukes inne i address_space. For eksempel { web = 0, app = 1 }"
  default = {
    web  = 0
    app  = 1
    data = 2
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Felles tags fra miljøet."
}