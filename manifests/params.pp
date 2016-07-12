class icinga::params {
  $objects_dir = '/etc/icinga/objects'
  $hosts = 'hosts'
  $services = 'services'
  $contacts = 'contacts'
  $commands = 'commands'
  $templates = 'templates'

  $module_dir = "${::puppet_vardir}/exported/icinga"
  $service_collects = "${module_dir}/services"
  $host_collects = "${module_dir}/hosts"
  $hostgroup_collects = "${module_dir}/hostgroups"

  $hosts_dir = "${objects_dir}/${hosts}"
  $services_dir = "${objects_dir}/${services}"
  $contacts_dir = "${objects_dir}/${contacts}"
  $commands_dir = "${objects_dir}/${commands}"
  $templates_dir = "${objects_dir}/${templates}"

  $scripts_dir = "/etc/icinga/scripts"

  $nrpe_dir = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/nrpe.d',
    'Darwin'  => '/opt/local/etc/nrpe/nrpe.d',
    default   => '/etc/nagios/nrpe.d',
  }

  $master = $::icinga_master ? {
    ''      => "icinga.${::domain}",
    default => $::icinga_master,
  }

  $pluginsdir = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/libexec/nagios',
    default   => '/usr/lib/nagios/plugins',
  }
  # legacy
  $nagiosplugins = $pluginsdir

  $owner = 'nagios'
  $group = 'nagios'

  File {
    owner => $owner,
    group => $group,
  }
}
