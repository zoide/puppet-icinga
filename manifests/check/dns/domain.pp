define icinga::check::dns::domain (
  $ensure        = 'present',
  $dns_domain    = undef,
  $server        = undef,
  $servicegroups = 'DNS',
  $expected_host = undef) {
  $dom_real = $dns_domain ? {
    undef   => $name,
    default => $dns_domain
  }
  $expected_real = $expected_host ? {
    undef   => '',
    default => " -a ${expected_host}"
  }

  case $server {
    undef   : {
      $serv_real = ''
      $serv_desc = 'system DNS'
    }
    default : {
      $serv_real = " -s ${server}" # whitespace important!
      $serv_desc = $server
    }
  }

  icinga::object::nrpe_service { "${fqdn}_dns_${name}":
    service_description => "DNS ${dom_real} on ${serv_desc}",
    command_name        => "check_dns_${name}",
    command_line        => "/usr/lib/nagios/plugins/check_dns -H ${dom_real}${serv_real}${expected_real}",
    servicegroups       => $servicegroups,
    ensure              => $ensure,
  }
}