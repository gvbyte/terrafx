# signalfx_text_chart.test_dash_0_0:
resource "signalfx_text_chart" "test_dash_0_0" {
  markdown = <<-EOF
        <table width="100%" height="50%" rules="none"><tr><td valign="middle" align="center" bgcolor="#4682B4">
        <font size="5" color="white">Scripps Health <DASH_NAME> Servers</font>
        </td></tr></table>
    EOF
  name     = " "
}
# signalfx_heatmap_chart.test_dash_0_1:
resource "signalfx_heatmap_chart" "test_dash_0_1" {
  description      = "Heatmap showing CPU Utilization % for all servers divided by group"
  disable_sampling = true
  group_by = [
    "description",
  ]
  hide_timestamp     = true
  max_delay          = 0
  minimum_resolution = 0
  name               = "Hosts"
  program_text       = "A = data('cpu.utilization').publish(label='A')"
  sort_by            = "+host"
  unit_prefix        = "Metric"

  color_scale {
    color = "lime_green"
    gt    = 340282346638528860000000000000000000000
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 25
  }
  color_scale {
    color = "red"
    gt    = 75
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 340282346638528860000000000000000000000
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 25
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 50
  }
  color_scale {
    color = "yellow"
    gt    = 50
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 75
  }
}
# signalfx_event_feed_chart.test_dash_0_2:
resource "signalfx_event_feed_chart" "test_dash_0_2" {
  name         = "Event Feed"
  program_text = <<-EOF
        B = data('SS').publish(label='B')
        C = alerts(detector_name='Device Engineering').publish(label='C')
    EOF
  time_range   = 86400
}
# signalfx_single_value_chart.test_dash_0_3:
resource "signalfx_single_value_chart" "test_dash_0_3" {
  color_by                = "Dimension"
  is_timestamp_hidden     = true
  max_precision           = 4
  name                    = "Active Hosts"
  program_text            = "A = data('cpu.utilization', extrapolation='last_value', maxExtrapolations=2).mean(by=['host']).count().publish(label='A')"
  refresh_interval        = 300
  secondary_visualization = "None"
  show_spark_line         = false
  unit_prefix             = "Metric"

  viz_options {
    color        = "blue"
    display_name = "cpu.utilization - COUNT"
    label        = "A"
  }
}
# signalfx_time_chart.test_dash_0_4:
resource "signalfx_time_chart" "test_dash_0_4" {
  axes_include_zero  = false
  axes_precision     = 0
  color_by           = "Dimension"
  description        = "Line graph for historical analysis of servers losing connection or power."
  disable_sampling   = false
  minimum_resolution = 0
  name               = "Total Active Hosts"
  plot_type          = "LineChart"
  program_text       = "A = data('cpu.utilization', filter=(not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*')), extrapolation='last_value', maxExtrapolations=2).mean(by=['host']).count().publish(label='A')"
  show_data_markers  = false
  show_event_lines   = false
  stacked            = false
  time_range         = 900
  unit_prefix        = "Metric"

  histogram_options {
    color_theme = "red"
  }

  viz_options {
    axis         = "left"
    color        = "blue"
    display_name = "cpu.utilization - COUNT"
    label        = "A"
  }
}
# signalfx_list_chart.test_dash_0_5:
resource "signalfx_list_chart" "test_dash_0_5" {
  color_by                = "Scale"
  disable_sampling        = false
  hide_missing_values     = true
  max_delay               = 0
  max_precision           = 0
  name                    = "Top Network Bytes In"
  program_text            = "A = data('system.network.io', filter=filter('direction', 'receive') and filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).mean(by=['host']).publish(label='A')"
  refresh_interval        = 5
  secondary_visualization = "Sparkline"
  sort_by                 = "-value"
  time_range              = 900
  unit_prefix             = "Binary"

  color_scale {
    color = "light_blue"
    gt    = 0
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 340282346638528860000000000000000000000
  }
  color_scale {
    color = "light_blue"
    gt    = 340282346638528860000000000000000000000
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 0
  }

  legend_options_fields {
    enabled  = false
    property = "host.name"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = true
    property = "host"
  }

  viz_options {
    display_name = "system.network.io - Mean by host"
    label        = "A"
    value_unit   = "Byte"
  }
}
# signalfx_list_chart.test_dash_0_6:
resource "signalfx_list_chart" "test_dash_0_6" {
  color_by                = "Scale"
  disable_sampling        = false
  hide_missing_values     = true
  max_delay               = 0
  max_precision           = 0
  name                    = "Top Network Bytes Out"
  program_text            = "A = data('system.network.io', filter=filter('direction', 'transmit') and filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).mean(by=['host']).publish(label='A')"
  refresh_interval        = 5
  secondary_visualization = "Sparkline"
  sort_by                 = "-value"
  time_range              = 900
  unit_prefix             = "Binary"

  color_scale {
    color = "navy"
    gt    = 0
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 340282346638528860000000000000000000000
  }
  color_scale {
    color = "navy"
    gt    = 340282346638528860000000000000000000000
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 0
  }

  legend_options_fields {
    enabled  = false
    property = "host.name"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = true
    property = "host"
  }

  viz_options {
    display_name = "system.network.io - Mean by host"
    label        = "A"
    value_unit   = "Byte"
  }
}
# signalfx_list_chart.test_dash_0_7:
resource "signalfx_list_chart" "test_dash_0_7" {
  color_by                = "Scale"
  disable_sampling        = false
  hide_missing_values     = true
  max_delay               = 0
  max_precision           = 0
  name                    = "Top 10 Memory Utilization"
  program_text            = "A = data('memory.utilization').top(count=10).publish(label='A')"
  secondary_visualization = "Linear"
  sort_by                 = "-value"
  time_range              = 900
  unit_prefix             = "Metric"

  color_scale {
    color = "lime_green"
    gt    = 340282346638528860000000000000000000000
    gte   = 0
    lt    = 340282346638528860000000000000000000000
    lte   = 25
  }
  color_scale {
    color = "red"
    gt    = 75
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 100
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 25
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 50
  }
  color_scale {
    color = "yellow"
    gt    = 50
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 75
  }

  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = true
    property = "host.name"
  }
  legend_options_fields {
    enabled  = false
    property = "os.type"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = true
    property = "host"
  }
  legend_options_fields {
    enabled  = true
    property = "environment"
  }
  legend_options_fields {
    enabled  = true
    property = "description"
  }

  viz_options {
    display_name = "memory.utilization - Top 10"
    label        = "A"
  }
}
# signalfx_list_chart.test_dash_0_8:
resource "signalfx_list_chart" "test_dash_0_8" {
  color_by                = "Scale"
  disable_sampling        = false
  hide_missing_values     = true
  max_delay               = 0
  max_precision           = 0
  name                    = "Top 10 Disks Free Space (GB)"
  program_text            = <<-EOF
        A = data('system.filesystem.usage', filter=filter('state', 'free') and filter('device', 'C:')).bottom(count=10).publish(label='A', enable=False)
        C = (A/1024/1024/1024).publish(label='C')
    EOF
  secondary_visualization = "Linear"
  sort_by                 = "+value"
  time_range              = 900
  unit_prefix             = "Metric"

  color_scale {
    color = "light_green"
    gt    = 60
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 80
  }
  color_scale {
    color = "lime_green"
    gt    = 80
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 100
  }
  color_scale {
    color = "red"
    gt    = 340282346638528860000000000000000000000
    gte   = 0
    lt    = 340282346638528860000000000000000000000
    lte   = 20
  }
  color_scale {
    color = "vivid_yellow"
    gt    = 40
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 60
  }
  color_scale {
    color = "yellow"
    gt    = 20
    gte   = 340282346638528860000000000000000000000
    lt    = 340282346638528860000000000000000000000
    lte   = 40
  }

  legend_options_fields {
    enabled  = true
    property = "host.name"
  }
  legend_options_fields {
    enabled  = true
    property = "description"
  }
  legend_options_fields {
    enabled  = true
    property = "mountpoint"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = false
    property = "device"
  }
  legend_options_fields {
    enabled  = false
    property = "fs_type"
  }
  legend_options_fields {
    enabled  = false
    property = "host"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = false
    property = "mode"
  }
  legend_options_fields {
    enabled  = false
    property = "os.type"
  }
  legend_options_fields {
    enabled  = false
    property = "state"
  }
  legend_options_fields {
    enabled  = false
    property = "type"
  }
  legend_options_fields {
    enabled  = false
    property = "environment"
  }
  legend_options_fields {
    enabled  = true
    property = "address"
  }
  legend_options_fields {
    enabled  = true
    property = "contact"
  }

  viz_options {
    display_name = "GB Free"
    label        = "C"
  }
  viz_options {
    display_name = "system.filesystem.usage - Bottom 10"
    label        = "A"
  }
}
# signalfx_time_chart.test_dash_0_9:
resource "signalfx_time_chart" "test_dash_0_9" {
  axes_include_zero         = false
  axes_precision            = 0
  color_by                  = "Dimension"
  disable_sampling          = false
  name                      = "Network Bytes In  vs. 24h Change %"
  on_chart_legend_dimension = "plot_label"
  plot_type                 = "ColumnChart"
  program_text              = <<-EOF
        A = data('system.network.io', filter=filter('direction', 'receive') and filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).sum().scale(60).mean(over='1h').publish(label='A')
        C = (A).timeshift('1d').publish(label='C', enable=False)
        D = (A/C-1).scale(100).publish(label='D')
    EOF
  show_data_markers         = false
  show_event_lines          = false
  stacked                   = false
  time_range                = 3600
  unit_prefix               = "Binary"

  histogram_options {
    color_theme = "red"
  }

  viz_options {
    axis         = "left"
    display_name = "A - Timeshift 1d"
    label        = "C"
  }
  viz_options {
    axis         = "left"
    color        = "blue"
    display_name = "bytes in"
    label        = "A"
    value_unit   = "Byte"
  }
  viz_options {
    axis         = "right"
    color        = "orange"
    display_name = "24h change %"
    label        = "D"
    plot_type    = "LineChart"
    value_unit   = "Byte"
  }
}
# signalfx_time_chart.test_dash_0_10:
resource "signalfx_time_chart" "test_dash_0_10" {
  axes_include_zero         = false
  axes_precision            = 0
  color_by                  = "Dimension"
  disable_sampling          = false
  name                      = "Network Bytes Out  vs. 24h Change %"
  on_chart_legend_dimension = "plot_label"
  plot_type                 = "ColumnChart"
  program_text              = <<-EOF
        A = data('system.network.io', filter=filter('direction', 'transmit') and filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).sum().scale(60).mean(over='1h').publish(label='A')
        C = (A).timeshift('1d').publish(label='C', enable=False)
        D = (A/C-1).scale(100).publish(label='D')
    EOF
  show_data_markers         = false
  show_event_lines          = false
  stacked                   = false
  time_range                = 3600
  unit_prefix               = "Binary"

  histogram_options {
    color_theme = "red"
  }

  viz_options {
    axis         = "left"
    display_name = "A - Timeshift 1d"
    label        = "C"
  }
  viz_options {
    axis         = "left"
    color        = "blue"
    display_name = "bytes out"
    label        = "A"
    value_unit   = "Byte"
  }
  viz_options {
    axis         = "right"
    color        = "orange"
    display_name = "24h change %"
    label        = "D"
    plot_type    = "LineChart"
    value_unit   = "Byte"
  }
}
# signalfx_list_chart.test_dash_0_11:
resource "signalfx_list_chart" "test_dash_0_11" {
  color_by                = "Metric"
  disable_sampling        = false
  hide_missing_values     = false
  max_delay               = 0
  max_precision           = 0
  name                    = "Total Network Errors"
  program_text            = <<-EOF
        A = data('system.network.errors', filter=filter('direction', 'receive') and filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).count().publish(label='A')
        B = data('system.network.errors', filter=filter('direction', 'transmit') and filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).count().publish(label='B')
    EOF
  secondary_visualization = "Sparkline"
  time_range              = 900
  unit_prefix             = "Metric"

  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = true
    property = "sf_metric"
  }

  viz_options {
    color        = "blue"
    display_name = "errors with bytes in"
    label        = "A"
  }
  viz_options {
    color        = "orange"
    display_name = "errors with bytes out"
    label        = "B"
  }
}
# signalfx_list_chart.test_dash_0_12:
resource "signalfx_list_chart" "test_dash_0_12" {
  color_by                = "Dimension"
  disable_sampling        = false
  hide_missing_values     = true
  max_precision           = 0
  name                    = "Top Mem Page Swaps/sec"
  program_text            = <<-EOF
        A = data('vmpage_io.swap.in', filter=filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*'))).mean(by=['host']).top(count=5).publish(label='A')
        B = data('vmpage_io.swap.out', filter=filter('host', '*') and (not filter('cloud.provider', '*')) and (not filter('AWSUniqueId', '*')) and (not filter('gcp_id', '*')) and (not filter('azure_resource_id', '*')) and (not filter('kubernetes_node', '*')), rollup='delta').mean(by=['host']).top(count=5).publish(label='B')
    EOF
  refresh_interval        = 60
  secondary_visualization = "Sparkline"
  sort_by                 = "-value"
  time_range              = 900
  unit_prefix             = "Metric"

  legend_options_fields {
    enabled  = true
    property = "host.name"
  }
  legend_options_fields {
    enabled  = false
    property = "sf_originatingMetric"
  }
  legend_options_fields {
    enabled  = true
    property = "sf_metric"
  }
  legend_options_fields {
    enabled  = true
    property = "host"
  }

  viz_options {
    color        = "blue"
    display_name = "pages swapped in/sec"
    label        = "A"
  }
  viz_options {
    color        = "orange"
    display_name = "pages swapped out/sec"
    label        = "B"
  }
}
# signalfx_dashboard.test_dash_0:
resource "signalfx_dashboard" "test_dash_0" {
  charts_resolution = "default"
  dashboard_group   = signalfx_dashboard_group.test.id
  name              = "<DASH_NAME>"
  time_range        = "-3d"

  chart {
    chart_id = signalfx_single_value_chart.test_dash_0_3.id
    column   = 6
    height   = 1
    row      = 3
    width    = 3
  }
  chart {
    chart_id = signalfx_list_chart.test_dash_0_12.id
    column   = 3
    height   = 1
    row      = 6
    width    = 3
  }
  chart {
    chart_id = signalfx_time_chart.test_dash_0_10.id
    column   = 3
    height   = 1
    row      = 5
    width    = 3
  }
  chart {
    chart_id = signalfx_list_chart.test_dash_0_7.id
    column   = 6
    height   = 3
    row      = 4
    width    = 3
  }
  chart {
    chart_id = signalfx_time_chart.test_dash_0_4.id
    column   = 9
    height   = 1
    row      = 3
    width    = 3
  }
  chart {
    chart_id = signalfx_list_chart.test_dash_0_5.id
    column   = 0
    height   = 1
    row      = 4
    width    = 3
  }
  chart {
    chart_id = signalfx_event_feed_chart.test_dash_0_2.id
    column   = 6
    height   = 2
    row      = 1
    width    = 6
  }
  chart {
    chart_id = signalfx_list_chart.test_dash_0_11.id
    column   = 0
    height   = 1
    row      = 6
    width    = 3
  }
  chart {
    chart_id = signalfx_list_chart.test_dash_0_6.id
    column   = 3
    height   = 1
    row      = 4
    width    = 3
  }
  chart {
    chart_id = signalfx_heatmap_chart.test_dash_0_1.id
    column   = 0
    height   = 3
    row      = 1
    width    = 6
  }
  chart {
    chart_id = signalfx_time_chart.test_dash_0_9.id
    column   = 0
    height   = 1
    row      = 5
    width    = 3
  }
  chart {
    chart_id = signalfx_list_chart.test_dash_0_8.id
    column   = 9
    height   = 3
    row      = 4
    width    = 3
  }
  chart {
    chart_id = signalfx_text_chart.test_dash_0_0.id
    column   = 0
    height   = 1
    row      = 0
    width    = 12
  }

  filter {
    apply_if_exist = false
    negated        = false
    property       = "description"
    values = [
      "*<DASH_FILTER>*",
    ]
  }

  permissions {
    parent = signalfx_dashboard_group.test.id
  }

  variable {
    alias                  = "desc."
    apply_if_exist         = false
    property               = "description"
    replace_only           = false
    restricted_suggestions = false
    value_required         = false
    values                 = []
    values_suggested       = []
  }
  variable {
    alias                  = "server"
    apply_if_exist         = false
    property               = "host.name"
    replace_only           = true
    restricted_suggestions = false
    value_required         = false
    values                 = []
    values_suggested       = []
  }
}
