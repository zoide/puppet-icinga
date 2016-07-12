class icinga::monitored::common ($ensure = 'present') inherits icinga::client {
  Icinga::Object::Service {
    ensure => $ensure, }

  icinga::object::service { "${::fqdn}_ssh":
    service_description => 'SSH',
    check_command       => 'check_ssh_port!22',
    notification_period => 'workhours',
  }

  icinga::object::service { "${::fqdn}_ping":
    service_description => 'PING',
    check_command       => 'check_ping!125.0,20%!500.0,60%',
  }

  icinga::object::service { "${::fqdn}_load":
    service_description => 'LOAD',
    check_command       => 'check_load',
    ensure              => 'absent'
  }

  case $::kernel {
    'Linux' : { $apt_present = 'present' }
    default : { $apt_present = 'absent' }
  }

  if defined(Class['icinga::monitored::server_nrpe']) {
    icinga::object::nrpe_service { "${::fqdn}_nrpe_apt":
      command_name          => 'check_apt',
      command_line          => '/usr/lib/nagios/plugins/check_apt',
      service_description   => 'APT',
      normal_check_interval => '1440',
      notification_interval => '50400',
      notification_period   => 'workhours',
      notification_options  => 'w,c',
      notifications_enabled => '0',
      ensure                => 'absent',
    }

    icinga::object::nrpe_command { 'check_disk':
      command_line => '/usr/lib/nagios/plugins/check_disk -c 10% -w 20%',
      ensure       => $ensure,
    }

  }
}
