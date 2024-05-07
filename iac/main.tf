resource "azurerm_network_security_group" "net_sec_group" {
  name                = "container-apps-network-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "container_app_env" {
  name                       = "container-environment"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
}

resource "azurerm_container_app" "container_app_jellyfin" {
  name                         = "container-app-jellyfin"
  container_app_environment_id = azurerm_container_app_environment.container_app_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "jellyfin"
      image  = "jellyfin/jellyfin:latest"
      cpu    = 1.0
      memory = "2.0Gi"
    }
    min_replicas = 0
    max_replicas = 2
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
