class nginx_remove {

  service { 'nginx':
    ensure => stopped,
  }

  package { 'nginx':
    ensure => absent,
  }

  file { '/etc/nginx':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  file { '/var/www/html/index.html':
    ensure => absent,
    force  => true,
  }

  notify { "Nginx successfully removed from this node!": }
}
