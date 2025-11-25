class nginx_install {

  package { 'nginx':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "Welcome to DevOps ETP\n",
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure     => running,
    enable     => true,
    require    => File['/var/www/html/index.html'],
  }

  notify { "Successful Nginx installation on this node!":
    require => Service['nginx'],
  }

}
