class icinga::check::pgsql {
  icinga::service { "${fqdn}_pgsql":
    service_description  => 'POSTGRESQL',
    check_command        => 'check_pgsql2',
    notification_options => 'w,c,u',
  }
}
