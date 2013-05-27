# Configure a Debian based GitLab server (gitlab.domain.tld)
node /gitlab_server/ {

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }

  $gitlab_dbname  = 'gitlab_prod'
  $gitlab_dbuser  = 'labu'
  $gitlab_dbpwd   = 'labpass'


  class { 'apt::update': stage => first; }

  # Manage redis and nginx server
  class { 'redis': stage => main; }
  class { 'nginx': stage => main; }

  # git://github.com/puppetlabs/puppetlabs-postgresql.git
  class {
    'postgresql::server':
      stage   => main,
      require => Exec['apt_update'];
  }

  postgresql::db {
    $gitlab_dbname:
      user     => $gitlab_dbuser,
      password => $gitlab_dbpwd,
  }

  postgresql::database_user {
    $gitlab_dbuser:
      password_hash => 'foo',
  }

  postgresql::database_grant{
    $gitlab_dbname:
      privilege => 'ALL',
      db        => $gitlab_dbname,
      role      => $gitlab_dbuser,
  }

  class {
    'gitlab':
      stage             => last,
      git_user          => 'git',
      git_home          => '/home/git',
      git_email         => 'notifs@foobar.fr',
      git_comment       => 'GitLab',
      # Setup gitlab sources and branch (default to GIT proto)
      gitlab_sources    => 'https://github.com/gitlabhq/gitlabhq.git',
      gitlab_domain     => 'gitlab.localdomain.local',
      gitlab_dbtype     => 'pgsql',
      gitlab_dbname     => $gitlab_dbname,
      gitlab_dbuser     => $gitlab_dbuser,
      gitlab_dbpwd      => $gitlab_dbpwd,
      ldap_enabled      => false,
  }
}
