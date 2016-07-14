class icinga::master::actions inherits icinga::params {
  Exec {
    notify      => Service['icinga'],
    refreshonly => true,
    logoutput   => true,
    user        => 'root',
  }

  exec { 'actions::update-unique-service-checks': command => "${icinga::params::scripts_dir}/unique_checks.rb ${icinga::params::service_collects} ${icinga::params::services_dir}", 
  }

  exec { 'actions::generate-hostgroup-membership': command => "${icinga::params::scripts_dir}/generate_hostgroups.rb ${icinga::params::hostgroup_collects} ${icinga::params::hosts_dir}", 
  }
}
