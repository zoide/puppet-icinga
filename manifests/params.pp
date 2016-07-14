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

  $nagios_user = $::operatingsystem ? {
    'Darwin' => 'daemon',
    default  => 'nagios',
  }
  $nagios_group = $::operatingsystem ? {
    'Darwin' => 'daemon',
    default  => 'nagios',
  }

  File {
    owner => $nagios_user,
    group => $nagios_group,
  }

  $nrpe_service = $::operatingsystem ? {
    'FreeBSD' => 'nrpe2',
    'Darwin'  => 'org.macports.nrpe',
    default   => 'nagios-nrpe-server',
  }
  $nrpe_package = $::operatingsystem ? {
    'FreeBSD' => 'nrpe2',
    'Darwin'  => 'nrpe',
    default   => 'nagios-nrpe-server',
  }

  $nagiosconf = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/nagios',
    'Darwin'  => '/opt/local/etc/nrpe',
    default   => '/etc/nagios',
  }
  $nrpebin = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/sbin/nrpe2',
    'Darwin'  => '/opt/local/sbin/nrpe',
    default   => '/usr/sbin/nrpe',
  }

  $nrpecfg = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/nrpe.cfg',
    'Darwin'  => '/opt/local/etc/nrpe/nrpe.cfg',
    default   => '/etc/nagios/nrpe.cfg',
  }
  $nrpecfg_local = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/nrpe_local.cfg',
    'Darwin'  => '/opt/local/etc/nrpe/nrpe_local.cfg',
    default   => '/etc/nagios/nrpe_local.cfg',
  }

  $sudobin = $::kernel ? {
    'FreeBSD' => '/usr/local/bin/sudo',
    default   => '/usr/bin/sudo',
  } }
