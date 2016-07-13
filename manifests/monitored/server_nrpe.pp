class icinga::monitored::server_nrpe ($ensure = 'present') {
  include icinga::params

  class { 'icinga::monitored::server': }

  File {
    require => Package[$icinga::params::nrpe_package] }

  file {
    $icinga::params::nrpecfg:
      content => template('icinga/nrpe.cfg.erb');

    $icinga::params::nrpecfg_local:
    ;
  }

  if $kernel == 'Darwin' {
    Package {
      provider => 'darwinport', }

    exec { 'restart-nagios-nrpe':
      command  => 'launchctl stop org.macports.nrpe && sleep 2 && launchctl stop org.macports.nrpe && launchctl start org.macports.nrpe',
      path     => ['/bin'],
      schedule => 'daily',
    }
  }

  package { $icinga::params::nrpe_package: ensure => installed, }

  case $::operatingsystem {
    'Debian', 'Ubuntu' : {
      package { ['nagios-plugins', 'nagios-plugins-standard', 'nagios-plugins-basic']: ensure => $ensure, }
    }
    'Darwin'           : {
      package { 'nagios-plugins': ensure => $ensure, }
    }
  }

  file { "${nagiosconf}/nrpe.d":
    ensure => 'directory',
    owner  => $icinga::params::nagios_user,
    group  => $icinga::params::nagios_group,
  }

  #  exec { 'generate-nrpe.cfg':
  #    command     => "cat ${nagiosconf}/nrpe.d/* >${nagiosconf}/nrpe_local.cfg",
  #    refreshonly => true,
  #    subscribe   => File["${nagiosconf}/nrpe.d"],
  #    notify      => Service[$icinga::params::nrpe_service],
  #  }

  service { $icinga::params::nrpe_service:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '/usr/sbin/nrpe.*',
    require    => Package[$icinga::params::nrpe_package],
    subscribe  => [
      File["${icinga::params::nrpecfg}"],
      File["${icinga::params::nrpecfg_local}"]],
  }

  #  }
  $swap_present = $swapsize ? {
    '0.00 MB' => 'absent',
    ''        => 'absent',
    undef     => 'absent',
    default   => $ensure ? {
      'absent' => 'absent',
      default  => 'present'
    } }

  icinga::object::nrpe_service {
    "${fqdn}_nrpe_swap":
      command_name         => 'check_swap',
      command_line         => "${icinga::params::nagiosplugins}/check_swap -w 3% -c 1%",
      service_description  => 'SWAP',
      notification_options => 'w,c,u',
      servicegroups        => 'Harddrives,Memory',
      ensure               => $swap_present;

    "${fqdn}_check_diskspace":
      command_name          => 'check_diskspace',
      command_line          => "${icinga::params::nagiosplugins}/check_disk -l -X devfs -X linprocfs -X devpts -X tmpfs -X usbfs -X procfs -X proc -X sysfs -X iso9660 -X debugfs -X binfmt_misc -X udf -X devtmpfs -X securityfs -X fusectl -w 10% -c 5%",
      service_description   => 'DISKSPACE',
      notification_period   => 'workhours',
      notification_interval => '1440',
      servicegroups         => 'Harddrives',
  }

  icinga::object::service {
    "${fqdn}_nrpe_users ":
      service_description   => 'LOGGEDIN_USERS',
      check_command         => 'check_nrpe_1arg!check_users',
      notifications_enabled => '1',
      notification_period   => 'workhours',
      notification_options  => 'w,c,u';

    "${fqdn}_nrpe_zombie_processes":
      service_description => 'ZOMBIE_PROCS',
      check_command       => 'check_nrpe_1arg!check_zombie_procs',
      notification_period => 'workhours',
  }
  $processorcount_real = $processorcount ? {
    ''      => 1,
    default => $processorcount,
  }
  $procs_warn = $processorcount_real * 100
  $procs_crit = $processorcount_real * 150

  icinga::object::nrpe_service { "${fqdn}_nrpe_processes":
    command_name         => 'check_procs',
    command_line         => "${icinga::params::nagiosplugins}/check_procs -w ${procs_warn} -c ${procs_crit}",
    service_description  => 'RUNNING_PROCS',
    notification_period  => 'workhours',
    notification_options => 'w,c,u',
  }

  $crit_one = $processorcount_real * 5.5
  $crit_five = $processorcount_real * 5
  $crit_fifteen = $processorcount_real * 4.5
  $warn_one = $processorcount_real * 3.5
  $warn_five = $processorcount_real * 3.0
  $warn_fifteen = $processorcount_real * 2.5

  icinga::object::nrpe_service { "${fqdn}_nrpe_load":
    service_description  => 'LOAD',
    command_name         => 'check_load',
    command_line         => "${icinga::params::nagiosplugins}/check_load -w ${warn_one},${warn_five},${warn_fifteen} -c ${crit_one},${crit_five},${crit_fifteen}",
    notification_options => 'w,c,u',
    ensure               => $ensure,
  }
}
