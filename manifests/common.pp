class icinga::common ($ensure = 'present') {
  include icinga::params

  if $ensure == 'present' {
    file { '/var/cache/nagios':
      owner   => $icinga::params::owner,
      group   => $icinga::params::group,
      recurse => true,
      ensure  => 'directory',
    }
  }
}
