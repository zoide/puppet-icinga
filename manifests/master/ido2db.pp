class icinga::master::ido2db (
  $ensure        = 'present',
  $use_ssl       = '0',
  $db_servertype = 'mysql',
  $db_host       = 'localhost',
  $db_port       = '3306',
  $db_name       = 'icinga',
  $db_prefix     = 'icinga_',
  $db_user       = 'icinga-idoutils',
  $db_password   = 'xxspKttyzq10') {
  include icinga::params

  package { 'icinga-idoutils': ensure => $ensure }

  File {
    ensure => $ensure,
    owner  => 'nagios',
    group  => 'nagios',
    mode   => '0600',
    notify => Service['ido2db'],
  }

  if $ensure == 'present' {
    File {
      require => Package['icinga-idoutils'], }
  }

  file {
    '/etc/icinga/ido2db.cfg':
      content => template('icinga/ido2db.cfg.erb');

    '/etc/icinga/idomod.cfg':
      content => template('icinga/idomod.cfg.erb');

    '/etc/icinga/modules/idoutils.cfg':
      source => 'puppet:///modules/icinga/idoutils.cfg',
      notify => Service['icinga'];
    #    "${icinga::params::objects_dir}/ido2db_check_proc.cfg":
    #      content => template('icinga/ido2db_check_proc.cfg.erb'),
    #      notify  => Service['icinga'];
  }

  # enable idoutils in /etc/default/icinga
  File_line {
    path => '/etc/default/icinga', }

  if $ensure == 'absent' {
    Service {
      before => File_line['idoutils_IDO2DB=no add'], }
  } else {
    File_line {
      notify => Service['ido2db'], }
  }

  case $ensure {
    'present' : {
      $ido2db_add = 'IDO2DB=yes'
      $ido2db_rm = 'IDO2DB=no'
    }
    default   : {
      $ido2db_add = 'IDO2DB=no'
      $ido2db_rm = 'IDO2DB=yes'
    }
  }

  file_line {
    "idoutils_${ido2db_add} add":
      line => $ido2db_add;

    "idoutils_${ido2db_rm} remove":
      line   => $ido2db_rm,
      ensure => 'absent',
  }

  $run = $ensure ? {
    'present' => 'running',
    default   => 'stopped',
  }
  $enable = $ensure ? {
    'present' => true,
    default   => false,
  }

  service { 'ido2db':
    ensure => $run,
    enable => $enable,
  }

  mysql::db { $db_name:
    ensure   => $ensure,
    user     => $db_user,
    password => $db_password,
    notify   => Service['ido2db'],
    require  => Package['icinga-idoutils'],
    sql      => '/usr/share/dbconfig-common/data/icinga-idoutils/install/mysql',
  }

  # # Have it checked:
  icinga::object::service { 'ido2db-proc-service':
    active_checks_enabled        => '1',
    passive_checks_enabled       => '1',
    parallelize_check            => '1',
    obsess_over_service          => '1',
    check_freshness              => '0',
    notifications_enabled        => '1',
    event_handler_enabled        => '1',
    flap_detection_enabled       => '1',
    failure_prediction_enabled   => '1',
    process_perf_data            => '1',
    retain_status_information    => '1',
    retain_nonstatus_information => '1',
    is_volatile                  => '0',
    check_period                 => '24x7',
    max_check_attempts           => '3',
    normal_check_interval        => '10',
    retry_check_interval         => '2',
    notification_options         => 'w,u,c,r',
    notification_interval        => '60',
    notification_period          => '24x7',
    register                     => '0',
  }
}
