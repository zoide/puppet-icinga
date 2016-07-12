class icinga::check::web::all (
  $ensure = "present") {
  class { ["icinga::check::web::http", "icinga::check::web::https"]: ensure => 
    $ensure, }
}