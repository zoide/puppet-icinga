class icinga::master::default_env {
  Icinga::Object::Hostgroup {
    ensure => $ensure, }

  icinga::object::hostgroup {
    [
      'Debian',
      'Ubuntu',
      'FreeBSD',
      'Darwin',
      'debian',
      'ubuntu',
      'freebsd',
      'darwin']:
    ;

    [
      'physical',
      'xenu',
      'xen0',
      'kvm',
      'vpn',
      'lxc']:
    ;

    [
      'ppc',
      'amd64',
      'i386',
      'x86_64']:
    ;
  }

  icinga::object::servicegroup { ['Packages', 'DNS', 'Harddrives', 'Backup', 'Memory']: }

  # #some additional commands
  icinga::object::command {
    'check-nfsv4':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -C nfs -c2,3,4';

    'check-nfsv4-tcp':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -C nfs -t -c2,3,4';

    'check-nfsv3':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -C nfs -c2,3';

    'check-nfsv3-tcp':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -C nfs -t -c2,3';


    'check-rpc-tcp':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -C $ARG1$ -t';

    'check-rpc-version':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -C $ARG1$ -c $ARG2$';

    'check-rpc-version-tcp':
      command_line => '$USER1$/check_rpc -H $HOSTADDRESS$ -t -C $ARG1$ -c $ARG2$';
  }
}