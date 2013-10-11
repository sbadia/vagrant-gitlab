# Configure a GitLab server (gitlab.domain.tld)
node /gitlab_server/ {
  $gitlab_dbname  = 'gitlab_prod'
  $gitlab_dbuser  = 'labu'
  $gitlab_dbpwd   = 'labpass'

  exec { 'initial update':
    command   => '/usr/bin/apt-get update',
  }
  Exec['initial update'] -> Package <| |>

  # Manage redis and nginx server
  include redis
  include nginx

  file { '/etc/nginx/conf.d/default.conf':
    ensure  => absent,
    notify  => Class['nginx::service'],
  }

  class {
    'ruby':
      version         => $ruby_version,
      rubygems_update => false;
  }

  class {
    'ruby::dev':
      require => Class['ruby'],
      before  => Class['gitlab::setup'],
  }

  if $::lsbdistcodename == 'precise' {
    package {
      ['build-essential','libssl-dev','libgdbm-dev','libreadline-dev',
      'libncurses5-dev','libffi-dev','libcurl4-openssl-dev']:
        ensure => installed,
        before => Class['gitlab::setup'],
    }

    $ruby_version = '4.9'

    exec {
      'ruby-version':
        command     => '/usr/bin/update-alternatives --set ruby /usr/bin/ruby1.9.1',
        user        => root,
        logoutput   => 'on_failure',
        before      => Class['gitlab::setup'];
      'gem-version':
        command     => '/usr/bin/update-alternatives --set gem /usr/bin/gem1.9.1',
        user        => root,
        logoutput   => 'on_failure',
        before      => Class['gitlab::setup'];
    }
  } else {
    $ruby_version = '1:1.9.3'
  }

  # git://github.com/puppetlabs/puppetlabs-mysql.git
  include mysql::server

  mysql::db {
    $gitlab_dbname:
      ensure   => 'present',
      charset  => 'utf8',
      user     => $gitlab_dbuser,
      password => $gitlab_dbpwd,
      host     => 'localhost',
      grant    => ['all'],
      # See http://projects.puppetlabs.com/issues/17802 (thanks Elliot)
      require  => Class['mysql::config'],
      before   => Class['gitlab::setup'],
  }

  class {
    'gitlab':
      git_user       => 'git',
      git_home       => '/home/git',
      git_email      => 'notifs@foobar.fr',
      git_comment    => 'GitLab',
      gitlab_sources => 'https://github.com/gitlabhq/gitlabhq.git',
      gitlab_domain  => 'gitlab.localdomain.local',
      gitlab_dbtype  => 'mysql',
      gitlab_dbname  => $gitlab_dbname,
      gitlab_dbuser  => $gitlab_dbuser,
      gitlab_dbpwd   => $gitlab_dbpwd,
      ldap_enabled   => false,
      require        => [Class['redis'], Class['nginx'], Class['ruby::dev']]
  }
}
