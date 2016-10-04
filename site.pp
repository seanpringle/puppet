
node /./
{
  require base

  class { 'base::postgresql':
    version => '9.6',
    auth => 'trust',
    config  => {
      shared_buffers => '4GB',
      effective_cache_size => '8GB',
      work_mem => '64GB',
      maintenance_work_mem => '1GB',
    }
  }

  firewall { '80':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
    source => '150.203.248.222/32',
  }

  selboolean { 'httpd_can_network_connect':
    persistent => true,
    value      => on,
  }

  class { 'apache':
    default_vhost => false,
  }

  include apache::mod::proxy

  apache::listen { '80': }

  apache::vhost { 'localhost':
    ip => '*',
    ip_based => true,
    docroot => '/var/www/html',
    proxy_pass => [
      { 'path' => '/', 'url' => 'http://127.0.0.1:8080/', },
    ],
  }
}
