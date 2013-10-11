# Configure a GitLab server (gitlab.domain.tld)
node /gitlab_server/ {
  $gitlab_dbname  = 'gitlab_prod'
  $gitlab_dbuser  = 'labu'
  $gitlab_dbpwd   = 'labpass'

  exec { 'initial update':
    command   => '/usr/bin/apt-get update',
  }
  Exec['initial update'] -> Package <| |>

  class { 'gitlab_requirements':
    gitlab_dbname   => $gitlab_dbname,
    gitlab_dbuser   => $gitlab_dbuser,
    gitlab_dbpwd    => $gitlab_dbpwd,
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
  }

  Class['gitlab_requirements'] -> Class['gitlab'] ->
  file { '/etc/nginx/conf.d/default.conf':
    ensure => absent,
  } ->
  exec { '/usr/sbin/service nginx reload': }
}
