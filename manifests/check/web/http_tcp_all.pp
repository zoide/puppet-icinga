
class icinga::check::web::http_tcp_all (
  $ensure = "present") {
  Icinga::Object::Service {
    ensure => $ensure }

  icinga::object::service { "${::fqdn}_http_tcp":
    service_description => "HTTPTCP",
    check_command       => "check_tcp!80",
  }

  icinga::object::service { "${::fqdn}_https_tcp":
    service_description => "HTTPSTCP",
    check_command       => "check_tcp!443",
  }
}
