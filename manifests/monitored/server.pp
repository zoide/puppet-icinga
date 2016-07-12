
class icinga::monitored::server ($ensure = 'present') {
  class { 'icinga::monitored::common': ensure => $ensure }

  # define this host for nagios
  icinga::object::host { $::fqdn:
    hostgroups => "${::domain},${::operatingsystem},${::virtual},${::architecture}",
    ensure     => $ensure,
  }
}
