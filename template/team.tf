
data "http" "get_members" {
  for_each = var.members
  url      = "<API_URL>/v2/organization/member?query=email:${each.key}"
  request_headers = {
    X-SF-TOKEN = "${var.signalfx_auth_token}"
  }
}




resource "signalfx_team" "<TEAM_ID>" {
  name        = "<TEAM_NAME>"
  description = ""
  
  members = [for member in data.http.get_members : jsondecode(member.body)["results"][0]["id"]]

}