
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
    'rtorrent',
  ]

  package { $packages:
    ensure => present,
  }

  vcsrepo { '/usr/local/srv/slua':
    ensure   => latest,
    provider => git,
    source   => "https://github.com/seanpringle/slua.git",
    revision => 'master',
  }
}
