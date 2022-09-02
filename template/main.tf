
# HTTP request to get team(s) ID based on name
data "http" "get_team" {
  for_each = var.team
  url      = "<API_URL>/v2/team?name=${each.key}"
  request_headers = {
    X-SF-TOKEN = "${var.signalfx_auth_token}"
  }
}
# HTTP request to get member(s) ID based on name
data "http" "get_members" {
  for_each = var.members
  url      = "<API_URL>/v2/organization/member?query=email:${each.key}"
  request_headers = {
    X-SF-TOKEN = "${var.signalfx_auth_token}"
  }
}

# HTTP request to get admin(s) ID based on name
data "http" "get_admin_team_0" {
  for_each = var.admin_team_0
  url      = "<API_URL>/v2/team?name=${each.key}"
  request_headers = {
    X-SF-TOKEN = "${var.signalfx_auth_token}"
  }
}

data "http" "get_admin_team_1" {
  for_each = var.admin_team_1
  url      = "<API_URL>/v2/team?name=${each.key}"
  request_headers = {
    X-SF-TOKEN = "${var.signalfx_auth_token}"
  }
}
