class icinga::master::web (
  $db_rootpass,
  $rootpassword     = 'rootpass',
  $ensure           = 'present',
  $db_rootuser      = 'root',
  $db_servertype    = 'mysql',
  $db_host          = 'localhost',
  $db_port          = '3306',
  $db_name          = 'icinga_web',
  $db_prefix        = 'icinga_',
  $db_user          = 'icinga_web',
  $db_password      = 'xxspKttyzq10',
  $db_method        = 'unix socket',
  $webserver        = 'apache2',
  $ldap_dsn         = false,
  $ldap_start_tls   = true,
  $ldap_basedn      = false,
  $ldap_binddn      = false,
  $ldap_bindpw      = false,
  $ldap_userattr    = 'uid',
  $ldap_filter_user = '(&(uid=__USERNAME__))') {
  # ## ICINGA WEB2 #####
  package { [
    'php-pear',
    'php5-xsl',
    'php5-ldap',
    'php5-pgsql',
    'php5-mysql',
    'php5-xmlrpc',
    'icinga-phpapi']:
    ensure => $ensure,
  }

  apt::preseed { 'icinga-web':
    content => template('icinga/icinga-web.seeds.erb'),
    ensure  => $ensure,
  }

  File {
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0600',
    notify => Exec['icinga-web-clearcache'],
  }

  file {
    '/etc/icinga-web/conf.d/database-web.xml':
      content => template('icinga/database-web.xml.erb'),
      require => Apt::Preseed['icinga-web'];

    '/etc/icinga-web/conf.d/databases.xml':
      content => template('icinga/databases.xml.erb'),
      require => Apt::Preseed['icinga-web'];

    '/etc/icinga-web/conf.d/auth.xml':
      content => template('icinga/icinga-web-auth.xml.erb'),
      require => Apt::Preseed['icinga-web'];
  }

  exec { 'icinga-web-clearcache':
    refreshonly => true,
    command     => '/usr/lib/icinga-web/bin/clearcache.sh',
  }

  mysql::db { $db_name:
    user     => $db_user,
    password => $db_password,
    before   => Apt::Preseed['icinga-web'],
  }
}
