
class base::postgresql(
  $version = '9.5',
  $config  = { },
  $sources = [ ],
  $auth = 'ident',
){

  class { 'postgresql::globals':
    version => $version,
    manage_package_repo => true,
  }->
  class { 'postgresql::server':
    listen_addresses => '*',
    pg_hba_conf_defaults => false,
  }

  postgresql::server::pg_hba_rule { "postgres ${auth}":
    type        => 'local',
    user        => 'postgres',
    database    => 'postgres',
    auth_method => $auth,
  }

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
