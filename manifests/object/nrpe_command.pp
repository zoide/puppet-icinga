define icinga::object::nrpe_command ($command_line, $command_name = '', $ensure = 'present', $sudo = false, $register = '1') {
  $cmd_real = $command_name ? {
    ''      => $name,
    default => $command_name,
  }
  $sudobin = $::kernel ? {
    'FreeBSD' => '/usr/local/bin/sudo',
    default   => '/usr/bin/sudo',
  }

  case $sudo {
    true    : {
      sudoers { "icinga::sudo_${::hostname}_${cmd_real}":
        ensure   => $ensure,
        hosts    => 'ALL',
        users    => 'nagios',
        commands => "NOPASSWD: ${command_line}",
      }
    }
    default : {
    }
  }
  $command_line_real = $sudo ? {
    true    => "${sudobin} ${command_line}",
    default => $command_line,
  }
  $nrpe_d = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/nrpe.d',
    'Darwin'  => '/opt/local/etc/nrpe/nrpe.d',
    default   => '/etc/nagios/nrpe.d',
  }

  if ($command_line_real != '') {
    file { "${nrpe_d}/${name}.cfg":
      ensure  => $ensure,
      content => "command[${cmd_real}]=${command_line_real}\n",
    # notify  => Exec['generate-nrpe.cfg']
    }
  }
}
