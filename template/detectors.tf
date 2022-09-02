# signalfx_detector.detector-temp:
resource "signalfx_detector" "<TEAM_ID>_detector" {
  disable_sampling = false
  max_delay         = 0
  min_delay         = 0
  name              = "<TEAM_NAME>"
  program_text      = <<-EOF
        from signalfx.detectors.against_periods import against_periods
        A = data('cpu.utilization', filter=filter('description', '<TEAM_NAME>')).publish(label='A')
        B = data('memory.utilization', filter=filter('description', '<TEAM_NAME>')).publish(label='B')
        C = data('disk.utilization', filter=filter('mountpoint', '*') and filter('description', '<TEAM_NAME>')).publish(label='C')
        D = data('system.network.errors', filter=filter('description', '<TEAM_NAME>')).publish(label='D')
        detect(when(A < threshold(0.01), lasting='15m'), auto_resolve_after='3d').publish('HeartBeat Check')
        detect(when(A > threshold(99), lasting='30m', at_least=1), auto_resolve_after='3d').publish('CPU Utilization > 99% over 30m')
        against_periods.detector_mean_std(stream=B, window_to_compare='1d', space_between_windows='5d', num_windows=5, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='out_of_band', auto_resolve_after='3d').publish('Memory Utilization')
        detect(when(C > threshold(95), lasting='15m'), auto_resolve_after='3d').publish('Disk Utilization Above 95%')
        detect(when(C > threshold(99), lasting='5m'), auto_resolve_after='3d').publish('Disk Utilization Above 99%')
        against_periods.detector_mean_std(stream=D, window_to_compare='1d', space_between_windows='5d', num_windows=5, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='out_of_band', auto_resolve_after='3d').publish('System Network Errors')
    EOF
  show_data_markers = true
  show_event_lines  = false
  teams             = []
  time_range        = 43200

  rule {
    description  = "The 1d moving average of memory.utilization (assumed to be cyclical over 5d periods) is more than 5 standard deviation(s) below its historical norm."
    detect_label = "Memory Utilization"
    disabled     = false
    notifications = [
    "Team,${signalfx_team.<TEAM_ID>.id}",
    ]
    parameterized_body    = <<-EOF
            {{#if anomalous}}
            Host: {{dimensions.[host.name]}}
            OS: {{dimensions.[os.type]}}
            Assignment Group: <TEAM_NAME>
            State: {{anomalyState}}
            Time Triggered: {{dateTimeFormat timestamp format="full"}}
            {{else}}
            Host: {{dimensions.host}}  cleared at {{dateTimeFormat timestamp format="full"}}.
            State: {{anomalyState}}
            Time Cleared: {{dateTimeFormat timestamp format="full"}}
            {{/if}}
            
            {{#if anomalous}}
            {{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
            {{#if tip}}Tip: {{{tip}}}{{/if}}
            {{/if}}
        EOF
    parameterized_subject = "({{{detectorName}}}) {{ruleSeverity}} Alert: {{{ruleName}}} on {{dimensions.[host.name]}}{{detectorId}}"
    severity              = "Warning"
  }
  rule {
    description  = "The 1d moving average of system.network.errors (assumed to be cyclical over 5d periods) is more than 5 standard deviation(s) below its historical norm."
    detect_label = "System Network Errors"
    disabled     = false
    notifications = [
    "Team,${signalfx_team.<TEAM_ID>.id}",
    ]
    parameterized_body    = <<-EOF
            {{#if anomalous}}
            Host: {{dimensions.[host.name]}}
            OS: {{dimensions.[os.type]}}
            Assignment Group: <TEAM_NAME>
            State: {{anomalyState}}
            Time Triggered: {{dateTimeFormat timestamp format="full"}}
            {{else}}
            Host: {{dimensions.host}}  cleared at {{dateTimeFormat timestamp format="full"}}.
            State: {{anomalyState}}
            Time Cleared: {{dateTimeFormat timestamp format="full"}}
            {{/if}}
            
            
            {{#if anomalous}}
            {{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
            {{#if tip}}Tip: {{{tip}}}{{/if}}
            {{/if}}
        EOF
    parameterized_subject = "{{ruleSeverity}} Alert: {{{ruleName}}} on {{dimensions.[host.name]}}"
    severity              = "Info"
  }
  rule {
    description  = "The value of cpu.utilization is above 99 for 30m."
    detect_label = "CPU Utilization > 99% over 30m"
    disabled     = false
    notifications = [
    "Team,${signalfx_team.<TEAM_ID>.id}",
    ]
    parameterized_body    = <<-EOF
            {{#if anomalous}}
            Host: {{dimensions.[host.name]}}
            OS: {{dimensions.[os.type]}}
            Assignment Group: <TEAM_NAME>
            State: {{anomalyState}}
            Time Triggered: {{dateTimeFormat timestamp format="full"}}
            {{else}}
            Host: {{dimensions.host}}  cleared at {{dateTimeFormat timestamp format="full"}}.
            State: {{anomalyState}}
            Time Cleared: {{dateTimeFormat timestamp format="full"}}
            {{/if}}
            
            {{#if anomalous}}
            {{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
            {{#if tip}}Tip: {{{tip}}}{{/if}}
            {{/if}}
        EOF
    parameterized_subject = "{{ruleSeverity}} Alert: {{{ruleName}}} ({{{detectorName}}})"
    severity              = "Info"
  }
  rule {
    description  = "The value of cpu.utilization is below 0.01."
    detect_label = "HeartBeat Check"
    disabled     = false
    notifications = [
    "Team,${signalfx_team.<TEAM_ID>.id}",
    ]
    parameterized_body    = <<-EOF
            {{#if anomalous}}
            Host: {{dimensions.[host.name]}}
            OS: {{dimensions.[os.type]}}
            Assignment Group: <TEAM_NAME>
            State: {{anomalyState}}
            Time Triggered: {{dateTimeFormat timestamp format="full"}}
            {{else}}
            Host: {{dimensions.host}}  cleared at {{dateTimeFormat timestamp format="full"}}.
            State: {{anomalyState}}
            Time Cleared: {{dateTimeFormat timestamp format="full"}}
            {{/if}}
            
            {{#if anomalous}}
            {{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
            {{#if tip}}Tip: {{{tip}}}{{/if}}
            {{/if}}
        EOF
    parameterized_subject = "{{ruleSeverity}} Alert: {{{ruleName}}} ({{{detectorName}}})"
    severity              = "Major"
  }
  rule {
    description  = "The value of disk.utilization is above 95."
    detect_label = "Disk Utilization Above 95%"
    disabled     = false
    notifications = [
    "Team,${signalfx_team.<TEAM_ID>.id}",
    ]
    parameterized_body    = <<-EOF
            {{#if anomalous}}
            Host: {{dimensions.[host.name]}}
            OS: {{dimensions.[os.type]}}
            Assignment Group: <TEAM_NAME>
            State: {{anomalyState}}
            Time Triggered: {{dateTimeFormat timestamp format="full"}}
            {{else}}
            Host: {{dimensions.host}}  cleared at {{dateTimeFormat timestamp format="full"}}.
            State: {{anomalyState}}
            Time Cleared: {{dateTimeFormat timestamp format="full"}}
            {{/if}}
            
            {{#if anomalous}}
            {{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
            {{#if tip}}Tip: {{{tip}}}{{/if}}
            {{/if}}
        EOF
    parameterized_subject = "{{ruleSeverity}} Alert: {{{ruleName}}}"
    severity              = "Major"
  }
  rule {
    description  = "The value of disk.utilization is above 99."
    detect_label = "Disk Utilization Above 99%"
    disabled     = false
    notifications = [
    "Team,${signalfx_team.<TEAM_ID>.id}",
    ]
    parameterized_body    = <<-EOF
            {{#if anomalous}}
            Host: {{dimensions.[host.name]}}
            OS: {{dimensions.[os.type]}}
            Assignment Group: <TEAM_NAME>
            State: {{anomalyState}}
            Time Triggered: {{dateTimeFormat timestamp format="full"}}
            {{else}}
            Host: {{dimensions.host}}  cleared at {{dateTimeFormat timestamp format="full"}}.
            State: {{anomalyState}}
            Time Cleared: {{dateTimeFormat timestamp format="full"}}
            {{/if}}
            
            {{#if anomalous}}
            {{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
            {{#if tip}}Tip: {{{tip}}}{{/if}}
            {{/if}}
        EOF
    parameterized_subject = "{{ruleSeverity}} Alert: {{{ruleName}}} on {{dimensions.[host.name]}}"
    severity              = "Major"
  }

  viz_options {
    display_name = "cpu.utilization"
    label        = "A"
  }
  viz_options {
    display_name = "disk.utilization"
    label        = "C"
  }
  viz_options {
    display_name = "memory.utilization"
    label        = "B"
  }
  viz_options {
    display_name = "system.network.errors"
    label        = "D"
  }
}
