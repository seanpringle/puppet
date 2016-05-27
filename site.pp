
node /./
{
  require base

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
    'rtorrent',
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

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { 'oneblueshoe.net':
    port    => '80',
    docroot => '/var/www/oneblueshoe.net',
  }

  class { 'base::postgresql':
    config => {
      shared_buffers => '128MB',
      effective_cache_size => '256MB',
    },
  }

  postgresql::server::db { 'wordipelago':
    user     => 'wordipelago',
    password => postgresql_password("wordipelago", $::config::password::wordipelago),
  }

}
