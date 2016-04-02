
class base::postgresql(
  $version = '9.5',
  $config  = { },
  $sources = [ ],
){

  class { 'postgresql::globals':
    version => $version,
    manage_package_repo => true,
  }->
  class { 'postgresql::server':
    listen_addresses => '*',
  }

#  package { 'postgresql95-devel.x86_64':
#    ensure => installed,
#  }

  $config.each |String $key, String $val|
  {
    postgresql::server::config_entry { $key:
      value => $val,
    }
  }

  $sources.each |String $source|
  {
    postgresql::server::pg_hba_rule { $source:
      type        => 'host',
      database    => 'all',
      user        => 'all',
      address     => $source,
      auth_method => 'md5',
    }
  }
}