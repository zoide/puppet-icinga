
define icinga::object::nrpe_service (
  $host_name       = $::fqdn,
  $hostgroup_name  = false,
  $service_description           = false,
  $command_name    = false,
  $command_line    = false,
  $template        = false,
  $use             = false,
  $servicegroups   = false,
  $is_volatile     = false,
  $initial_state   = 'o',
  $check_command   = false,
  $max_check_attempts            = '5',
  $check_interval  = '30',
  $retry_interval  = '15',
  $active_checks_enabled         = false,
  $passive_checks_enabled        = false,
  $check_period    = '24x7',
  $parallelize_check             = '1',
  $obsess_over_service           = false,
  $failure_prediction_enabled    = false,
  $check_freshness = '',
  $freshness_threshold           = '',
  $event_handler   = '',
  $event_handler_enabled         = '',
  $low_flap_threshold            = '',
  $high_flap_threshold           = '',
  $flap_detection_enabled        = '',
  $process_perf_data             = '',
  $retain_status_information     = '',
  $retain_nonstatus_information  = '',
  $notification_interval         = '1440',
  $notification_period           = '24x7',
  $notification_options          = 'w,u,c',
  $notifications_enabled         = '1',
  $contact_groups  = false,
  $stalking_options              = '',
  $dependent_service_description = false,
  $inherits_parent = '1',
  $execution_failure_criteria    = 'w,u,c,p',
  $notification_failure_criteria = 'w,u,c,p',
  $multiple_values_array         = '',
  $multiple_insertin             = '',
  $service_template              = false,
  $ensure          = 'present',
  $subdir          = 'services',
  $base_path       = '',
  $register        = false,
  $action_url      = false,
  $sudo            = false) {
  include icinga::params
  $cmd_real = $command_name ? {
    ''      => $name,
    default => $command_name,
  }

  icinga::object::nrpe_command { "icinga::nrpe_${command_name}_${host_name}":
    command_name => $cmd_real,
    command_line => $command_line,
    ensure       => $ensure,
    tag          => 'icinga',
    sudo         => $sudo,
    notify       => Service[$icinga::params::nrpe_service]
  }

  icinga::object::service { "icinga::${cmd_real}_${host_name}":
    host_name        => $host_name,
    service_description           => $service_description,
    hostgroup_name   => $hostgroup_name,
    servicegroups    => $servicegroups,
    is_volatile      => $is_volatile,
    check_period     => $check_period,
    check_command    => "check_nrpe_1arg!${cmd_real}",
    check_freshness  => $check_freshness,
    event_handler    => $event_handler,
    max_check_attempts            => $max_check_attempts,
    check_interval   => $check_interval,
    retry_interval   => $retry_interval,
    active_checks_enabled         => $active_checks_enabled,
    passive_checks_enabled        => $passive_checks_enabled,
    parallelize_check             => $parallelize_check,
    obsess_over_service           => $obsess_over_service,
    freshness_threshold           => $freshness_threshold,
    event_handler_enabled         => $event_handler_enabled,
    low_flap_threshold            => $low_flap_threshold,
    high_flap_threshold           => $high_flap_threshold,
    flap_detection_enabled        => $flap_detection_enabled,
    process_perf_data             => $process_perf_data,
    retain_status_information     => $retain_status_information,
    retain_nonstatus_information  => $retain_nonstatus_information,
    notification_interval         => $notification_interval,
    notification_period           => $notification_period,
    notification_options          => $notification_options,
    notifications_enabled         => $notifications_enabled,
    contact_groups   => $contact_groups,
    stalking_options => $stalking_options,
    dependent_service_description => $dependent_service_description,
    inherits_parent  => $inherits_parent,
    execution_failure_criteria    => $execution_failure_criteria,
    notification_failure_criteria => $notification_failure_criteria,
    multiple_values_array         => $multiple_values_array,
    multiple_insertin             => $multiple_insertin,
    ensure           => $ensure,
    tag              => 'icinga',
  }
}