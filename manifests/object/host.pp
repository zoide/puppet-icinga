define icinga::object::host (
  $host_name  = $::fqdn,
  $host_alias = $::hostname,
  $address    = $::ipaddress,
  $use        = false,
  $template   = false,
  $parents    = '',
  $hostgroups = '',
  $check_command                = 'check-host-alive',
  $max_check_attempts           = '5',
  $check_interval               = '',
  $active_checks_enabled        = '',
  $passive_checks_enabled       = '',
  $check_period                 = '24x7',
  $obsess_over_host             = '',
  $check_freshness              = '',
  $freshness_threshold          = '',
  $event_handler                = '',
  $event_handler_enabled        = '',
  $low_flap_threshold           = '',
  $high_flap_threshold          = '',
  $flap_detection_enabled       = '',
  $process_perf_data            = '',
  $retain_status_information    = '',
  $retain_nonstatus_information = '',
  $contact_groups               = false,
  $notification_interval        = '1440',
  $notification_period          = '24x7',
  $notification_options         = 'd,u,r',
  $notifications_enabled        = '1',
  $stalking_options             = '',
  $failure_prediction_enabled   = false,
  $first_notification_delay     = false,
  $retry_interval               = false,
  $ensure     = 'present',
  $subdir     = 'hosts',
  $register   = false,
  $action_url = false,
  $addfields  = false) {
  include icinga::params

  $name_real = $host_name ? {
    false   => $name,
    default => $host_name,
  }

  if !defined(Icinga::Object["host_${name_real}"]) {
    icinga::object { "host_${name_real}":
      ensure  => $ensure,
      content => template('icinga/host.erb'),
      subdir  => $subdir,
    }
  }
}
