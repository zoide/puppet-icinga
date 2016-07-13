class icinga::master::cgi ($ensure = 'present') {
  package { ['icinga-cgi', 'icinga-cgi-bin']: ensure => $ensure, }

  Exec {
    require => Package['icinga-cgi'] }

  exec {
    'dpkg-statoverride-/var/lib/icinga/rw':
      command => 'dpkg-statoverride --update --add nagios www-data 2710 /var/lib/icinga/rw',
      unless  => 'dpkg-statoverride --list /var/lib/icinga/rw';

    'dpkg-statoverride-/var/lib/icinga':
      command => 'dpkg-statoverride --update --add nagios nagios 751 /var/lib/icinga',
      unless  => 'dpkg-statoverride --list /var/lib/icinga';
  }
}
