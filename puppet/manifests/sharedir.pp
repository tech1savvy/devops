
group { 'devops':
  ensure => present,
}

user { 'devops':
  ensure     => present,
  gid        => 'devops',
  home       => '/home/devops',
  managehome => true,
}

file { '/opt/shared_data':
  ensure  => directory,
  owner   => 'devops',
  group   => 'devops',
  mode    => '0775',
  recurse => true,
  require => [ User['devops'], Group['devops'] ],
}
