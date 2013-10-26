
class postgres_db {

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  exec {'run-update':
    command => 'apt-get update',
    creates => '/usr/bin/postgres',
  }

  class { 'postgresql::server':
    config_hash => {
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users'    => '0.0.0.0/0',
        'listen_addresses'           => '*',
        'postgres_password'          => 'postgres',
        'manage_pg_hba_conf'         => true,
      },
    require     => Exec['run-update'],
  }

  postgresql::tablespace {'analytics_tablespace':
    location => '/myspace',
  }

  postgresql::db { 'postgres_db':
    user     => 'myusername',
    password => 'A$tup!dPa$$w0rd',
    tablespace => 'analytics_tablespace',
  }

  postgresql::pg_hba_rule {'allow local db access':
    type        => 'local',
    database    => 'all',
    user        => 'all',
    auth_method => 'trust',
    order       => '001',
  }

}

include postgres_db
