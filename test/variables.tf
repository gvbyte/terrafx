variable "signalfx_auth_token" {
  type = string

  default = "Jvb6veDUfkx5udXnzLTNCQ"
}

variable "signalfx_api_url" {
  type = string

  default = "https://api.us1.signalfx.com"
}

variable "signalfx_custom_url" {
  type = string

  default = "https://scripps.signalfx.com"
}

# Please make sure team exists in Splunk 011y

variable "teams" {
  type    = set(string)
  default = ["Computing"]
}


