
package { ['git', 'curl', 'vim']:
  ensure => installed,
}

service { 'cron':
  ensure => running,
  enable => true,
}

file { '/opt/tools':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

file { '/opt/tools/info.txt':
  ensure  => file,
  content => "System tools installed and managed by Puppet.\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

