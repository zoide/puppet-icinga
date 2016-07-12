class nagios::nsca::sender ($ensure = 'present') {
  include icinga::params

  package { 'nsca': ensure => $ensure }

  service { 'nsca':
    ensure  => 'stopped',
    require => Package['nsca'],
  }

  Line {
    ensure => $ensure,
    file   => '/etc/munin.munin.conf',
  }

  line {
    'munin_nsca_sender':
      line => 'contacts nagios';

    'munin_nsca_sender_command':
      line => "contact.nagios.command /usr/sbin/send_nsca -H ${icinga::params::master} -to 60 -c /etc/send_nsca.cfg";
  }
}
