output "rg_name" {
  description = "Navnet på resource group for webappen"
  value       = azurerm_resource_group.rg.name
}

output "plan_id" {
  description = "Ressurs-ID for App Service Plan"
  value       = azurerm_service_plan.plan.id
}

output "webapp_id" {
  description = "Ressurs-ID for Linux Web App"
  value       = azurerm_linux_web_app.app.id
}

output "webapp_url" {
  description = "URL til webappen"
  value       = azurerm_linux_web_app.app.default_hostname
}
