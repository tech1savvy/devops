class apache_install {

  package { 'apache2':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "Welcome to DevOps ETP\n",
    require => Package['apache2'],
  }

  service { 'apache2':
    ensure     => running,
    enable     => true,
    require    => File['/var/www/html/index.html'],
  }

  notify { "Successful Apache installation on this node!":
    require => Service['apache2'],
  }

}
