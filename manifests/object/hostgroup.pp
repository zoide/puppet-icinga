define icinga::object::hostgroup (
  $hostgroup_name    = undef,
  $hostgroup_alias   = undef,
  $hostgroup_members = false,
  $members           = false,
  $ensure            = 'present',
  $subdir            = 'hosts',
  $register          = false,
  $notes             = false,
  $notes_url         = false,
  $action_url        = false,
  $base_path         = '') {
  include icinga::params

  $hostgroup_name_real = $hostgroup_name ? {
    undef   => $name,
    default => $hostgroup_name,
  }

  $hostgroup_alias_real = $hostgroup_alias ? {
    undef   => $hostgroup_name_real,
    default => $hostgroup_alias
  }

  icinga::object { "group_${hostgroup_name_real}":
    ensure  => $ensure,
    content => template('icinga/hostgroup.erb'),
    subdir  => $subdir,
    path    => $base_path,
}
}
