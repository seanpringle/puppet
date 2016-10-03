
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

  firewall { '35000 dev':
    chain  => 'INPUT',
    proto  => 'tcp',
    dport  => '35000',
    action => 'accept',
  }
}
