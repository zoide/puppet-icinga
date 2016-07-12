class icinga::nsca::receiver ($ensure = 'present') {
  notice("NSCA should be \"${ensure}\"")

  package { 'nsca': ensure => $ensure }

  service { 'nsca':
    ensure  => 'stopped',
    require => Package['nsca'],
  }

  xinetd::service { 'nsca':
    server      => '/usr/sbin/nsca',
    server_args => '-c /etc/nsca.cfg --inetd',
    user        => 'nagios',
    group       => 'nagios',
    only_from   => '127.0.0.1 ganglia.ikw.Uni-Osnabrueck.DE',
    port        => 5667,
    ensure      => $ensure,
  }

  icinga::service { '${fqdn}_nsca_receiver':
    service_description => 'nsca',
    check_command       => 'check_tcp!5667',
    ensure              => $ensure,
  }

  icinga::command { 'dummy_command_for_nsca':
    command_name => 'check_dummy',
    command_line => '/usr/lib/nagios/plugins/check_dummy \$ARG1\$ \$ARG2\$',
    ensure       => 'present',
  }
}

