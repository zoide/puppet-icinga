class icinga::check::dns::ports ($ensure = 'present', $port = '53') {
  Icinga::Object::Service {
    ensure        => $ensure,
    servicegroups => 'DNS',
  }

  icinga::object::service { "${::fqdn}-dns_tcp":
    service_description => "DNS Port ${port}",
    check_command       => "check_tcp!${port}",
  }

}
