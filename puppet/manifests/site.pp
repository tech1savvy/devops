node default {

  package { 'apache2':
    ensure => installed,
  }

  file { '/var/www/html':
    ensure  => directory,
    require => Package['apache2'],
  }

  $hostname = $facts['hostname']
  $env_name = $environment

  file { '/var/www/html/index.html':
    ensure  => file,
    require => File['/var/www/html'],
    content => inline_epp(@("EOT")),
<html>
  <body>
    <p>Hostname: <%= $hostname %></p>
    <p>Environment: <%= $env_name %></p>
  </body>
</html>
EOT
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
    require => File['/var/www/html/index.html'],
  }

}
