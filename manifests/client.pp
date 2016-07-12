class icinga::client ($ensure = 'present') {
  include icinga::params
  require icinga::common

  if $ensure == 'present' {
    file { $icinga::params::pluginsdir:
      source       => ['puppet:///modules/icinga/plugins'],
      recurse      => true,
      sourceselect => 'all',
      ensure       => $ensure,
    }
  }

}
