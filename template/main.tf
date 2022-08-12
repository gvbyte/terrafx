#API calls to get team ID based on name
data "http" "get_team" {
  for_each = var.teams
  url      = "https://api.us1.signalfx.com/v2/team?name=${each.key}"
  request_headers = {
    X-SF-TOKEN = "${var.signalfx_auth_token}"
  }
}
