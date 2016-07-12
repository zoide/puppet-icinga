class icinga::check::web::http (
  $ensure = "present") {
  Icinga::Object::Service {
    ensure => $ensure }

  icinga::object::service { "${::fqdn}_http":
    service_description => "HTTP",
    check_command       => "check_http!${::fqdn}!${::ipaddress}",
  }
}