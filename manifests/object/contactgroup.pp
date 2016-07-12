
# define contactgroup{
# contactgroup_name contactgroup_name
#  alias alias
# members members
#}

define icinga::object::contactgroup (
  $members           = false,
  $contactgroup_name = '',
  $contactgroup_alias,
  $ensure            = 'present',
  $subdir            = 'contacts',
  $register          = '1') {
  include icinga::params
  $contactgroup_name_real = $contactgroup_name ? {
    ''      => $name,
    default => $contactgroup_name
  }

  icinga::object { "group_${contactgroup_name_real}":
    ensure  => $ensure,
    content => template('icinga/contactgroup.erb'),
    subdir  => $subdir,
  }
}
