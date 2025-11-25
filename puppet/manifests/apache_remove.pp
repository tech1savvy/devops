class apache_remove {

  service { 'apache2':
    ensure => stopped,
  }

  package { 'apache2':
    ensure => absent,
    purge  => true,
  }

  file { '/etc/apache2':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  file { '/var/www/html/index.html':
    ensure => absent,
    force  => true,
  }

  notify { "Apache successfully removed from this node!": }
}
