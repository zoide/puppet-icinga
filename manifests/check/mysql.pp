class icinga::check::mysql {
  icinga::service { "${fqdn}_mysql":
    service_description  => 'MYSQL',
    check_command        => 'check_mysql',
    notification_options => 'w,c,u',
  }
  $icingahost = gethostname($::icinga_host)

  mysql_user { "nagios@${icingahost}":
    ensure        => 'present',
    password_hash => ''
  }
}
