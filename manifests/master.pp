class icinga::master ($ensure = 'present', $icinga_master = $::fqdn) {
  include icinga::params
  include icinga::master_config
  require icinga::common

  if $ensure == 'present' {
    include icinga::master::actions
    include icinga::master::default_env
  }

  package { ['icinga-core', 'fdupes', 'nagios-nrpe-plugin']: ensure => $ensure }

  $run = $ensure ? {
    'present' => 'running',
    default   => 'stopped',
  }

  service { 'icinga':
    ensure    => $run,
    require   => Package['icinga-core'],
    subscribe => File[$icinga::params::objects_dir],
  }

  # collect all nagios_ definitions
  File <<| tag == 'icinga_object' |>> {
    notify  => [Exec['actions::update-unique-service-checks'], Exec['actions::generate-hostgroup-membership']],
    purge   => true,
    mode    => '0640',
    require => Class['icinga::master_config'],
  }

  Common::Line <<| tag == 'icinga_object' |>> {
    notify  => Exec['actions::generate-hostgroup-membership'],
    require => Class['icinga::master_config'],
  }

  if defined(Class['ganglia::monitor']) {
    file { "${icinga::params::nagiosplugins}/check_ganglia":
      source => 'puppet:///modules/ganglia/contrib/check_ganglia',
      mode   => '0755',
    }
  }
}
