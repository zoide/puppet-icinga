define icinga::object ($content, $ensure = 'present', $subdir = '', $path = '', $export_obj = true) {
  include icinga::params
  # nagios cannot read file with dots '.'
  $title_r = gsub(gsub($title, '\.', '-'), '\ ', '_')
  $subd_real = $subdir ? {
    ''      => '',
    default => "/${subdir}",
  }
  $path_real = $path ? {
    ''      => "${icinga::params::objects_dir}${subd_real}/${title_r}",
    default => "${path}/${title_r}",
  }

  if !defined(File["${path_real}.cfg"]) {
    if $export_obj {
      @@file { "${path_real}.cfg":
        ensure  => $ensure,
        content => $content,
        tag     => 'icinga_object',
        owner   => 'nagios',
        group   => 'nagios',
        purge   => true,
      }
    } else {
      file { "${path_real}.cfg":
        ensure  => $ensure,
        content => $content,
        tag     => 'icinga_object',
        owner   => 'nagios',
        group   => 'nagios',
        purge   => true,
      }
    }
  }
}
