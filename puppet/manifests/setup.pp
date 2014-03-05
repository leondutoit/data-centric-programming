
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
    version             => '9.3',
    manage_package_repo => true,
  }->

  class { 'postgresql::server':
    ensure                     => 'present',
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    postgres_password          => 'postgres',
    manage_pg_hba_conf         => true,
    require                    => Exec['run-update'],
  }

  class { 'postgresql::server::contrib': }

  postgresql::server::tablespace {'analytics_tablespace':
    location => '/myspace',
    require  => Class['postgresql::server'],
  }->

  postgresql::server::db { 'analytics_postgres':
    user       => 'IamMe',
    password   => 'letMein',
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

class utilities {

  package {'emacs':
    ensure  => 'present',
    require => Exec[run-update],
  }

  exec {'run-update':
    provider => shell,
    command  => '/usr/bin/apt-get update;',
  }

  package {'curl':
    ensure => 'present',
  }

}

class { 'apt': }

class r_dependencies {

  apt::source {'cran-mirror':
    location    => 'http://cran.uib.no/bin/linux/ubuntu',
    release     => 'precise/',
    repos       => '', # this is necessary due to the non-standard format of the cran apt source
    include_src => false,
  }

  apt::key {'cran-key':
    key        => 'E084DAB9',
    key_server => 'keyserver.ubuntu.com',
  }

}

class r_software {

  # Get the core environment
  package {['r-base', 'r-base-core', 'r-recommended', 'r-base-html']:
    ensure  => 'present',
    require => Class[r_dependencies],
  }

  # TODO (Leon) think about this and implement
  #exec {'r-packages':
  #  provider => shell,
  #  command  => '/usr/bin/R -f /vagrant/dependencies.r;',
  #  require  => Package[r-base],
  #}

}

include wget
include r_dependencies
include r_software
