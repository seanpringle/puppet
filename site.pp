
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

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { 'oneblueshoe.net':
    port    => '80',
    docroot => '/var/www/oneblueshoe.net',
  }
}
