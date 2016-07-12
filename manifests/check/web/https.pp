class icinga::check::web::https ($ensure = "present") {
  Icinga::Object::Service {
    ensure => $ensure }
  $fqdn_real = downcase($::fqdn)

  icinga::object::service { "${::fqdn}_https":
    service_description => "HTTPS",
    check_command       => "check_https!${fqdn_real}!${::ipaddress}",
  }
}