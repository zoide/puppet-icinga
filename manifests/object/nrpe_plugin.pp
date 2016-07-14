
define icinga::object::nrpe_plugin (
  $host_name        = $::fqdn,
  $service_description,
  $servicegroups    = '',
  $is_volatile      = '',
  $source           = 'plugins',
  $command_name     = '',
  $command_line     = '',
  $max_check_attempts            = '5',
  $check_interval         = '30',
  $retry_interval          = '15',
  $active_checks_enabled         = '',
  $passive_checks_enabled        = '',
  $check_period     = '24x7',
  $parallelize_check             = '1',
  $obsess_over_service           = '',
  $check_freshness  = '',
  $freshness_threshold           = '',
  $event_handler    = '',
  $event_handler_enabled         = '',
  $low_flap_threshold            = '',
  $high_flap_threshold           = '',
  $flap_detection_enabled        = '',
  $process_perf_data             = '',
  $retain_status_information     = '',
  $retain_nonstatus_information  = '',
  $notification_interval         = '120',
  $notification_period           = '24x7',
  $notification_options          = 'w,u,c,r',
  $notifications_enabled         = '1',
  $contact_groups   = '',
  $stalking_options = '',
  $dependent_service_description = '',
  $inherits_parent  = '1',
  $execution_failure_criteria    = 'w,u,c,p',
  $notification_failure_criteria = 'w,u,c,p',
  $multiple_values_array         = '',
  $multiple_insertin             = '',
  $ensure           = 'present',
  $sudo             = false) {
  $host_name_real = downcase($host_name)
  $sudobin = $::kernel ? {
    'FreeBSD' => '/usr/local/bin/sudo',
    default   => '/usr/bin/sudo',
  }
  $nagiosplugins = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/libexec/nagios',
    'Darwin'  => '/opt/local/libexec/nagios',
    default   => '/usr/lib/nagios/plugins',
  }
  $cmd_real = $command_name ? {
    ''      => $name,
    default => $command_name,
  }
  $cmdline_real = $command_line ? {
    ''      => "${nagiosplugins}/${cmd_real}",
    default => "${nagiosplugins}/${command_line}",
  }

  case $sudo {
    true  : {
      sudoers { "icinga::${::hostname}_${cmd_real}":
        hosts    => 'ALL',
        users    => 'nagios',
        commands => "NOPASSWD: ${cmdline_real}",
      }
      $command_line_real = "${sudobin} ${cmdline_real}"
    }
    false : {
      $command_line_real = $cmdline_real
      #         sudo::sudoer{"nagios_${ensure}_${hostname}":
      #            user => "nagios",
      #            host_name => $hostname,
      #            command => "NOPASSWD: ${command_line}",
      #         ensure => absent,
      #         }
    }
  }

  remotefile { "${nagiosplugins}/${cmd_real}":
    mode   => '0755',
    source => "${source}/${cmd_real}",
    ensure => $ensure,
    module => 'icinga',
  }

  icinga::object::nrpe_service { "icinga::${cmd_real}_${host_name}":
    host_name          => $host_name,
    service_description           => $service_description,
    servicegroups      => $servicegroups,
    is_volatile        => $is_volatile,
    command_name       => $cmd_real,
    command_line       => $command_line_real,
    max_check_attempts => $max_check_attempts,
    check_interval         => $check_interval,
    retry_interval          => $retry_interval,
    active_checks_enabled         => $active_checks_enabled,
    passive_checks_enabled        => $passive_checks_enabled,
    check_period       => $check_period,
    parallelize_check  => $parallelize_check,
    obsess_over_service           => $obsess_over_service,
    check_freshness    => $check_freshness,
    freshness_threshold           => $freshness_threshold,
    event_handler      => $event_handler,
    event_handler_enabled         => $event_handler_enabled,
    low_flap_threshold => $low_flap_threshold,
    high_flap_threshold           => $high_flap_threshold,
    flap_detection_enabled        => $flap_detection_enabled,
    process_perf_data  => $process_perf_data,
    retain_status_information     => $retain_status_information,
    retain_nonstatus_information  => $retain_nonstatus_information,
    notification_interval         => $notification_interval,
    notification_period           => $notification_period,
    notification_options          => $notification_options,
    notifications_enabled         => $notifications_enabled,
    contact_groups     => $contact_groups,
    stalking_options   => $stalking_options,
    dependent_service_description => $dependent_service_description,
    inherits_parent    => $inherits_parent,
    execution_failure_criteria    => $execution_failure_criteria,
    notification_failure_criteria => $notification_failure_criteria,
    multiple_values_array         => $multiple_values_array,
    multiple_insertin  => $multiple_insertin,
    ensure             => $ensure,
  }
}
