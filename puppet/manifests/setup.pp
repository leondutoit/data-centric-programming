
# Reference
# https://github.com/puppetlabs/puppetlabs-postgresql

class analytics_postgres {

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  exec {'run-update':
    command => 'apt-get update',
    creates => '/usr/bin/postgres',
  }

  class {'postgresql::globals':
    version => '9.3',
    manage_package_repo => true,
    #encoding => 'UTF8',
  }->

  class { 'postgresql::server':
    ensure => 'present',
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    postgres_password          => 'postgres',
    manage_pg_hba_conf         => true,
    require     => Exec['run-update'],
  }

  class { 'postgresql::server::contrib': }

  postgresql::server::tablespace {'analytics_tablespace':
    location => '/myspace',
    require => Class['postgresql::server'],
  }->

  postgresql::server::db { 'analytics_postgres':
    user     => 'IamMe',
    password => 'letMein',
    tablespace => 'analytics_tablespace',
  }

  postgresql::server::pg_hba_rule {'allow local db access':
    type        => 'local',
    database    => 'all',
    user        => 'all',
    auth_method => 'trust',
    order       => '001',
  }

  postgresql::server::pg_hba_rule {'allow local db access through md5':
    type        => 'host',
    database    => 'analytics_postgres',
    user        => 'IamMe',
    auth_method => 'md5',
    address     => 'all',
  }

}

include analytics_postgres
