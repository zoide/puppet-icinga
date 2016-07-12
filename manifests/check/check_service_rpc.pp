
class icinga::check::nfs::common {
  icinga::service { "${fqdn}_rpc_status":
    service_description => 'RPC_STATUS',
    check_command       => 'check-rpc!status',
  }

  icinga::service { "${fqdn}_rpc_status-tcp":
    service_description => 'RPC_STATUSTCP',
    check_command       => 'check-rpc-tcp!status',
  }

  icinga::service { "${fqdn}_rpc_portmap":
    service_description => 'RPC_PORTMAP',
    check_command       => 'check-rpc!portmap',
  }

  icinga::service { "${fqdn}_rpc_portmap-tcp":
    service_description => 'RPC_PORTMAPTCP',
    check_command       => 'check-rpc-tcp!portmap',
  }
}

class icinga::check::nfs inherits icinga::check::nfs::common {
  icinga::service { "${fqdn}_rpc":
    service_description => 'RPC_NFS',
    check_command       => 'check-nfsv3',
  }

  icinga::service { "${fqdn}_rpc-tcp":
    service_description => 'RPC_NFSTCP',
    check_command       => 'check-nfsv3-tcp',
  }

  icinga::service { "${fqdn}_rpc-nlockmgr":
    service_description => 'RPC_NLOCKMGR',
    check_command       => 'check-rpc-version!nlockmgr!1,3',
  }

  icinga::service { "${fqdn}_rpc-nlockmgr-tcp":
    service_description => 'RPC_NLOCKMGRTCP',
    check_command       => 'check-rpc-version-tcp!nlockmgr!1,3',
  }
}

class icinga::check::nfs::quota inherits icinga::check::nfs {
  icinga::service { "${fqdn}_rpc_quota":
    service_description => 'RPC_NFSQUOTA',
    check_command       => 'check-rpc!quota',
  }

  icinga::service { "${fqdn}_rpc_quota-tcp":
    service_description => 'RPC_NFSQUOTATCP',
    check_command       => 'check-rpc-tcp!quota',
  }
}

class icinga::check::nfs::quota::none {
  icinga::service { "${fqdn}_rpc_quota":
    service_description => 'RPC_NFSQUOTA',
    check_command       => 'check-rpc!quota',
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc_quota-tcp":
    service_description => 'RPC_NFSQUOTATCP',
    check_command       => 'check-rpc-tcp!quota',
    ensure              => 'absent',
  }
}

class icinga::check::nfs::none inherits icinga::check::nfs::common::none {
  icinga::service { "${fqdn}_rpc_quota":
    service_description => 'RPC_NFSQUOTA',
    check_command       => 'check-rpc!quota',
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc_quota-tcp":
    service_description => 'RPC_NFSQUOTATCP',
    check_command       => 'check-rpc-tcp!quota',
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc":
    service_description => 'RPC_NFS',
    check_command       => 'check-nfsv4',
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc-tcp":
    service_description => "RPC_NFSTCP",
    check_command       => "check-nfsv4-tcp",
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc-nlockmgr":
    service_description => "RPC_NLOCKMGR",
    check_command       => "check-rpc!nlockmgr",
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc-nlockmgr-tcp":
    service_description => "RPC_NLOCKMGRTCP",
    check_command       => "check-rpc-tcp!nlockmgr",
    ensure              => 'absent',
  }

}

class icinga::check::nfs::common::none {
  icinga::service { "${fqdn}_rpc_status":
    service_description => "RPC_STATUS",
    check_command       => "check-rpc!status",
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc_status-tcp":
    service_description => "RPC_STATUSTCP",
    check_command       => "check-rpc-tcp!status",
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc_portmap":
    service_description => "RPC_PORTMAP",
    check_command       => "check-rpc!portmap",
    ensure              => 'absent',
  }

  icinga::service { "${fqdn}_rpc_portmap-tcp":
    service_description => "RPC_PORTMAPTCP",
    check_command       => "check-rpc-tcp!portmap",
    ensure              => 'absent',
  }
}
