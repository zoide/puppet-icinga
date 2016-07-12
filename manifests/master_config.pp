class icinga::master_config ($ensure = 'present') {
  include icinga::params

  $ens_r = $ensure ? {
    'present' => 'directory',
    default   => $ensure,
  }

  File {
    ensure  => $ens_r,
    recurse => true,
    mode    => '0755',
    owner   => 'nagios',
    group   => 'nagios'
  }

  file {
    $icinga::params::objects_dir:
    ;

    [
      $icinga::params::hosts_dir,
      $icinga::params::services_dir,
      $icinga::params::contacts_dir,
      $icinga::params::commands_dir,
      $icinga::params::templates_dir]:
      require => [Package['icinga-core'], File[$icinga::params::objects_dir]];

    $icinga::params::module_dir:
    ;

    [
      $icinga::params::service_collects,
      $icinga::params::host_collects,
      $icinga::params::hostgroup_collects]:
      require => File[$icinga::params::module_dir];

    $icinga::params::scripts_dir:
      source => 'puppet:///modules/icinga/scripts',;
  }

  file { [
    "${icinga::params::objects_dir}/localhost_icinga.cfg",
    "${icinga::params::objects_dir}/hostgroups_icinga.cfg",
    "${icinga::params::objects_dir}/services_icinga.cfg",
    "${icinga::params::objects_dir}/extinfo_icinga.cfg"]:
    ensure => 'absent',
  }

  # # run daily audits
  cron { 'icinga_services_audit':
    command => "${icinga::params::scripts_dir}/icinga_defined_services_audit.rb |mail -E -s 'icinga audit: Services not defined' ${::root_mail}",
    special => 'daily',
    user    => 'root',
    ensure  => $ensure,
  }
}
