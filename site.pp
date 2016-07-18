
node /./
{
  require base
  require config

  firewall { '100 allow bitorrent':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '6881-6889',
    action => 'accept',
  }

  $packages = [
    'build-essential',
    'lua5.2',
    'liblua5.2-dev',
    'sqlite3',
    'libsqlite3-dev',
    'libssl-dev',
    'libpcre3-dev',
    'rtorrent',
    'lua-sql-postgres',
    'lua-json',
  ]

  package { $packages:
    ensure => present,
  }

  $path_slua = '/usr/local/src/slua'

  vcsrepo { $path_slua:
    ensure   => latest,
    provider => git,
    source   => "https://github.com/seanpringle/slua.git",
    revision => 'master',
  }

  firewall { '100 allow apache':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '100 allow apache ssl':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { 'oneblueshoe.net':
    port    => '80',
    docroot => '/var/www/oneblueshoe.net',
  }

  apache::vhost { '80 wordipelago.net':
    port    => '80',
    docroot => '/var/www/wordipelago.net',
    servername => 'wordipelago.net',
    serveraliases => [
      'www.wordipelago.net',
    ],
    proxy_pass => [
      { 'path' => '/api', 'url' => 'http://127.0.0.1:8080' },
    ]
  }

  apache::vhost { '443 wordipelago.net':
    ssl      => true,
    ssl_cert => '/etc/letsencrypt/live/www.wordipelago.net/fullchain.pem',
    ssl_key  => '/etc/letsencrypt/live/www.wordipelago.net/privkey.pem',
    port     => '443',
    docroot  => '/var/www/wordipelago.net',
    servername => 'wordipelago.net',
    serveraliases => [
      'www.wordipelago.net',
    ],
    proxy_pass => [
      { 'path' => '/api', 'url' => 'http://127.0.0.1:8080' },
    ]
  }

  class { 'base::postgresql':
    config => {
      shared_buffers => '128MB',
      effective_cache_size => '256MB',
    },
  }

  $password = $::config::password['wordipelago']

  postgresql::server::db { 'wordipelago':
    user     => 'wordipelago',
    password => postgresql_password("wordipelago", $password),
  }

  file { '/etc/wordipelago.pgsql':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('config/wordipelago.pgsql.erb'),
  }

}
