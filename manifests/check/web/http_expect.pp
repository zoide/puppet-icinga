define icinga::check::web::http_expect (
  $ensure = "present",
  $expect,
  $ssl    = "false") {
  $s = $ssl ? {
    "true" => "s",
  }

  icinga::object::service { "${::fqdn}_${name}":
    service_description => "${name}",
    check_command       => "check_http${s}_expect!${expect}",
    ensure              => $ensure,
  }
  $cmd_real = "/usr/lib/nagios/plugins/check_http -H '\$HOSTNAME\$' -e \$ARG1"

  if !defined(Icinga::Command["check_https_expect"]) {
    icinga::command { "check_https_expect": command_line => "${cmd_real} --ssl" 
    }
  }

  if !defined(Icinga::Command["check_http_expect"]) {
    icinga::command { "check_http_expect": command_line => "${cmd_real}" }
  }
}