define icinga::object::service (
  $host_name       = $::fqdn,
  $hostgroup_name  = false,
  $service_description           = false,
  $template        = false,
  $use             = false,
  $servicegroups   = false,
  $is_volatile     = false,
  $initial_state   = 'o',
  $check_command   = false,
  $max_check_attempts            = '5',
  $normal_check_interval         = '30',
  $retry_check_interval          = '15',
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
  $export_obj      = true) {
  include icinga::params

  $tmpl = $service_template ? {
    false   => 'icinga/service.erb',
    default => $service_template
  }

  $content = $dependent_service_description ? {
    false   => template($tmpl),
    default => template($tmpl, 'icinga/servicedependency.erb'),
  }

  icinga::object { "service_${service_description}_${name}":
    content    => $content,
    ensure     => $ensure,
    subdir     => $subdir,
    export_obj => $export_obj,
    path       => $base_path,
  }
}