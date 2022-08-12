terraform {
  required_providers {
    signalfx = {
      source  = "splunk-terraform/signalfx"
      version = "~> 6.13.1"
    }
  }
}

provider "signalfx" {
  auth_token = var.signalfx_auth_token
  # If your organization uses a different realm
  api_url = var.signalfx_api_url
  # If your organization uses a custom URL
  custom_app_url = var.signalfx_custom_url
}

provider "http" {}
