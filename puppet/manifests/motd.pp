file { '/etc/motd':
  ensure  => file,
  content => "This server is managed by Puppet Configuration Management System.\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}
