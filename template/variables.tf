# Please configure these variables in setup.py

variable "signalfx_auth_token" {
  type = string

  default = "<USER_API_KEY>"
}

variable "signalfx_api_url" {
  type = string

  default = "<API_URL>"
}

variable "signalfx_custom_url" {
  type = string

  default = "<ORG_URL>"
}

# Please make sure team exists in Splunk 011y
variable "team" {
  type    = set(string)
  default = ["<TEAM_NAME>"]
}

variable "members" {
  type    = set(string)
  default = ["<EMAIL>"]
}
