
class icinga::check::raid::software (
  $ensure = 'present') {
  $prese_real = $ensure ? {
    'absent' => 'absent',
    default  => $::has_raid ? {
      false   => 'absent',
      default => $ensure
    } }

  icinga::nrpe_plugin { "${::fqdn}_checkraid":
    ensure               => $prese_real,
    service_description  => 'CHECKRAID',
    command_name         => 'check_raid',
    servicegroups        => 'Harddrives',
    notification_options => 'w,c,u',
  }
}
