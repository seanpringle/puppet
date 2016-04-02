
node /./
{
  require base

  firewall { '200 allow postgres':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '5432',
    source => '10.100.53.0/24',
    action => 'accept',
  }

  class { 'base::postgresql':
    version => '9.5',
    sources => [ '10.100.53.0/24' ],
  }

  postgresql::server::db { 'test':
    user     => 'test',
    password => postgresql_password('test', 'test'),
  }
}
