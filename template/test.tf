# signalfx_dashboard_group.test:
resource "signalfx_dashboard_group" "test" {
  name = "<DASH_GROUP_NAME>"
  teams = [
    "<DASH_TEAM>",
  ]

  permissions {
    actions = [
      "READ",
      "WRITE",
    ]
    principal_id   = "FOJEY_7AwAE"
    principal_type = "TEAM"
  }
  permissions {
    actions = [
      "READ",
    ]
    principal_id   = "FOItL4QA4AA"
    principal_type = "TEAM"
  }
  permissions {
    actions = [
      "READ",
    ]
    principal_id   = "<DASH_TEAM>"
    principal_type = "TEAM"
  }
}
