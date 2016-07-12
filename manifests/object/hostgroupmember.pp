define icinga::object::hostgroupmember ($ensure = 'present', $hostgroup = '', $member = $::fqdn) {
  include 'icinga::params'

  $hgroup_r = $hostgroup ? {
    ''      => $name,
    default => $hostgroup
  }

  @@common::line { "hostgroup: ${hgroup_r} ${member}":
    file   => "${icinga::params::hostgroup_collects}/${hgroup_r}",
    ensure => $ensure,
    line   => $member,
    tag    => 'icinga_object',
  }
}
