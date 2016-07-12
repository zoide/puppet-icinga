class icinga::check::web::http_tcp (
  $ensure = "present") {
  Icinga::Object::Service {
    ensure => $ensure }

  icinga::object::service { "${::fqdn}_http_tcp":
    service_description => "HTTPTCP",
    check_command       => "check_tcp!80",
  }
}