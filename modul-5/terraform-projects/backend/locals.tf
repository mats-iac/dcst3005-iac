locals {
  # Principals to grant roles to
  principals = toset(
    concat(
      var.extra_principal_ids,
      var.assign_current_user ? [data.azurerm_client_config.current.object_id] : []
    )
  )
}