
resource "signalfx_dashboard_group" "<TEAM_ID>_dashgroup" {
  name  = "<TEAM_NAME>"
  teams = ["${signalfx_team.<TEAM_ID>.id}"]

  permissions {
    actions = [
      "READ",
      "WRITE",
    ]
    principal_id   = "<ADMIN_TEAM_0>"
    principal_type = "TEAM"
  }
  permissions {
    actions = [
      "READ",
    ]
    principal_id   = "<ADMIN_TEAM_1>"
    principal_type = "TEAM"
  }
  permissions {
    actions = [
      "READ",
    ]
    principal_id   = "${signalfx_team.<TEAM_ID>.id}"
    principal_type = "TEAM"
  }
}
