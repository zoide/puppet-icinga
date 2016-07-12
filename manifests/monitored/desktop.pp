# $Id$

class icinga::monitored::desktop inherits icinga::monitored::common {
# define this host for nagios
  icinga::host { $fqdn:
    hostgroups => "${domain},${operatingsystem},${virtual}",
	       notification_options => "n",
	       notification_period => "workhours",
  }
  icinga::nsca_service { "${fqdn}_diskspace":
    service_description => "DISKUSAGE",
			notification_period => "workhours",
			notification_options => "n",
    ensure => "absent",
  }
  icinga::nsca_service { "${fqdn}_load":
    service_description => "Load average",
			notification_period => "workhours",
			notification_options => "w,c,u",
  ensure => "absent",
  }
  }
