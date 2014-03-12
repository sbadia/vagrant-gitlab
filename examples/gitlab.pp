# Configure a GitLab server (gitlab.domain.tld)
#
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
      git_user                 => 'git',
      git_home                 => '/home/git',
      git_email                => 'gitlab@fooboozoo.fr',
      git_comment              => 'GitLab',
      gitlab_sources           => 'https://github.com/gitlabhq/gitlabhq.git',
      gitlab_domain            => 'gitlab.localdomain.local',
      gitlab_http_timeout      => '300',
      gitlab_dbtype            => 'mysql',
      gitlab_backup            => true,
      #gitlab_relative_url_root => '/gitlab',
      gitlab_dbname            => $gitlab_dbname,
      gitlab_dbuser            => $gitlab_dbuser,
      gitlab_dbpwd             => $gitlab_dbpwd,
      ldap_enabled             => false,
  }

  Class['gitlab_requirements'] -> Class['gitlab'] ->
  file { '/etc/nginx/conf.d/default.conf':
    ensure => absent,
  } ->
  exec { '/usr/sbin/service nginx reload': }
}
