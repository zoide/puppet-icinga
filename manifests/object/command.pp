define icinga::object::command ($command_line, $command_name = '', $subdir = 'commands', $ensure = 'present', $register = '1') {
  include icinga::params
  $cmd_real = $command_name ? {
    ''      => $name,
    default => $command_name,
  }

  icinga::object { "command_${cmd_real}":
    ensure  => $ensure,
      content => template('icinga/command.erb'),
      subdir  => $subdir,
    }
}
