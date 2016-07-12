define icinga::object::servicegroup (
  $ensure               = 'present',
  $servicegroup_name    = '',
  $servicegroup_alias   = '',
  $servicegroup_members = '',
  $subdir               = 'services',
  $register             = '1') {
  include icinga::params
  $servicegroup_name_real = $servicegroup_name ? {
    ''      => $name,
    default => $servicegroup_name,
  }

  icinga::object { "group_${servicegroup_name_real}":
    ensure  => $ensure,
    content => template('icinga/servicegroup.erb'),
    subdir  => $subdir,
  }
}
