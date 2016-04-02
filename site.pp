
node /./
{
  require base

  class { 'base::postgresql':
    version => '9.5',
    sources => [ '10.100.53.0/24' ],
  }

  postgresql::server::db { 'test':
    user     => 'test',
    password => postgresql_password('test', 'test'),
  }
}
