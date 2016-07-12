class icinga::master::cgi ($ensure = 'present') {
  package { 'icinga-cgi': ensure => $ensure, }
}
