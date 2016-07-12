
# define contact{
#  contact_name                    jdoe
#  alias                           John Doe
#  service_notification_period     24x7
#  host_notification_period        24x7
#  service_notification_options    w,u,c,r
#  host_notification_options       d,u,r
#  service_notification_commands   notify-service-by-email
#  host_notification_commands      notify-host-by-email
# email       jdoe@localhost.localdomain
# pager       555-5555@pagergateway.localhost.localdomain
#  address1      xxxxx.xyyy@icq.com
#  address2      555-555-5555
#  }
define icinga::object::contact (
  $email          = false,
  $ensure         = 'present',
  $contact_alias  = false,
  $contact_name   = false,
  $host_notifications_enabled    = '1',
  $service_notifications_enabled = '1',
  $service_notification_period   = '24x7',
  $host_notification_period      = '24x7',
  $service_notification_options  = 'w,u,c,r',
  $host_notification_options     = 'd,u,r',
  $service_notification_commands = 'notify-service-by-email',
  $host_notification_commands    = 'notify-host-by-email',
  $pager          = false,
  $contact_groups = false,
  $subdir         = 'contacts',
  $register       = false) {
  include icinga::params

  $contact_name_real = $contact_name ? {
    false   => $name,
    default => $contact_name
  }

  icinga::object { "contact_${contact_name_real}":
    ensure  => $ensure,
    content => template('icinga/contact.erb'),
    subdir  => $subdir,
  }
}
