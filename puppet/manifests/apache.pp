
package { 'apache2':
  ensure => installed,
}

service { 'apache2':
  ensure => running,
  enable => true,
  require => Package['apache2'],
}

file { '/var/www/html/index.html':
  ensure  => file,
  content => "Welcome to Puppet-managed Apache Server.\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  require => Package['apache2'],
}
