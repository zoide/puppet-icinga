define icinga::check::domain ($ensure = 'present', $dns_domain = undef, $server = undef, $servicegroups = 'DNS') {
  $dom_real = $dns_domain ? {
    undef   => $name,
    default => $dns_domain
  }

  case $server {
    undef   : {
      $serv_real = ''
      $serv_desc = 'system DNS'
    }
    default : {
      $serv_real = "-s ${server}"
      $serv_desc = $server
    }
  }

  icinga::object::nrpe_service { "${fqdn}_dns_${name}":
    service_description => "DNS ${dom_real} on ${serv_desc}",
    command_name        => "check_dns_${name}",
    command_line        => "/usr/lib/nagios/plugins/check_dns -H ${dom_real}${serv_real}",
    servicegroups       => $servicegroups,
    ensure              => $ensure,
  }
}