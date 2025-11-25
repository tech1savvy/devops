package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure => running,
  enable => true,
  require => Package['nginx'],
}

file { '/var/www/html/index.html':
  ensure  => file,
  content => "Welcome to the Nginx Web Server - Managed by Puppet.\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  require => Package['nginx'],
}
