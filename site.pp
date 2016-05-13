
node /./
{
  require base

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { 'oneblueshoe.net':
    port    => '80',
    docroot => '/var/www/oneblueshoe.net',
  }
}
