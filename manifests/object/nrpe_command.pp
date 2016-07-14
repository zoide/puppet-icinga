define icinga::object::nrpe_command ($command_line, $command_name = '', $ensure = 'present', $sudo = false, $register = '1') {
  include icinga::params
  $cmd_real = $command_name ? {
    ''      => $name,
    default => $command_name,
  }

  if $sudo {
    require sudo

    sudo::directive { "icinga::sudo_${::hostname}_${cmd_real}":
      ensure  => $ensure,
      content => "nagios ALL=(ALL:ALL) NOPASSWD: ${command_line}",
    }
  }
  $command_line_real = $sudo ? {
    true    => "${icinga::params::sudobin} ${command_line}",
    default => $command_line,
  }

  if ($command_line_real != '') {
    file { "${icinga::params::nrpe_dir}/${name}.cfg":
      ensure  => $ensure,
      content => "command[${cmd_real}]=${command_line_real}\n",
    }
  }
}
