
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
    'rtorrent',
  ]

  package { $packages:
    ensure => present,
  }
}
