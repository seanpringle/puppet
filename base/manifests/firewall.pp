
class base::firewall(
){

  resources { 'firewall':
    purge => true,
  }

  Firewall {
    before  => Class['base::firewall::post'],
    require => Class['base::firewall::pre'],
  }

  include firewall
  include base::firewall::pre
  include base::firewall::post

  firewall { '100 allow ssh':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '22',
    action => 'accept',
  }
}

class base::firewall::pre(
){

  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }->
  firewall { '003 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
}

class base::firewall::post(
){

  firewall { '999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
