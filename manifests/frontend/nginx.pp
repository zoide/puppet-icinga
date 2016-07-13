class icinga::frontend::nginx ($server_name = undef) {
  # # ICINGA:
  # https://git.icinga.org/?p=icinga-core.git;a=blob;f=contrib/nginx/README.nginx;h=1511116bb49e72a2a86d539348ac6b193c72bfdb;hb=HEAD;js=1
  package { ['fcgiwrap', 'nagios-images', 'icinga-doc']: }
  $ic_root = '/usr/share/icinga/htdocs'

  class { 'icinga::master::cgi': }
  $serv_name_real = $server_name ? {
    undef   => ['_'],
    default => $server_name,
  }

  nginx::resource::vhost { 'icinga':
    server_name          => $serv_name_real,
    use_default_location => false,
    www_root             => $ic_root,
    ssl                  => true,
    rewrite_to_https     => true,
  }

  Nginx::Resource::Location {
    vhost    => 'icinga',
    ssl      => true,
    ssl_only => true,
  }

  nginx::resource::location {
    [
      '/stylesheets',
      '/icinga/stylesheets']:
      location_alias => '/etc/icinga/stylesheets';

    [
      '/icinga/images',
      '/images']:
      location_alias => "${ic_root}/images";

    '/icinga/jquery-ui':
      location_alias => "${ic_root}/jquery-ui";

    '/icinga/js':
      location_alias => "${ic_root}/js";

    '/icinga':
      www_root    => $ic_root,
      index_files => ['index.html'];

    '~ /icinga/(.*)\.cgi$':
      rewrite_rules        => ['^/icinga/cgi-bin/(.*)\.cgi /$1.cgi break', '^/cgi-bin/icinga/(.*)\.cgi /$1.cgi break'],
      fastcgi              => 'unix:/var/run/fcgiwrap.socket',
      www_root             => '/usr/lib/cgi-bin/icinga',
      index_files          => ['index.php'],
      auth_basic           => 'Monime',
      auth_basic_user_file => '/etc/nginx/auth_basic.user',
      raw_append           => [
        'fastcgi_index index.php;',
        'fastcgi_param    SCRIPT_FILENAME    $document_root$fastcgi_script_name;',
        'fastcgi_param    AUTH_USER          $remote_user;',
        'fastcgi_param    REMOTE_USER        $remote_user;',
        ],
      location_cfg_append  => {
        fastcgi_connect_timeout => '3m',
        fastcgi_read_timeout    => '3m',
        fastcgi_send_timeout    => '3m'
      };
  }
}
