# == Class: apache
#
# Installs packages for Apache2, enables modules, and sets config files.
#
class apache {
  package { 'apache2':                ensure => present }
  package { 'apache2-mpm-prefork':    ensure => present }
  package { 'libapache2-modsecurity': ensure => present }

  service { 'apache2':
    ensure  => running,
    require => Package['apache2'];
  }

  # settings for apache2.conf and mpm_prefork.conf
  if $::instanceenv != 'development' {
    $startServers = 5
    $minSpareServers = 5
    $maxSpareServers = 10
    $maxRequestWorkers = 60
    $maxConnectionsPerChild = 5000
    $logLevel = 'error'
  } else {
    $startServers = 2
    $minSpareServers = 2
    $maxSpareServers = 5
    $maxRequestWorkers = 10
    $maxConnectionsPerChild = 500
    $logLevel = 'debug'
  }

  file {
    '/etc/apache2/apache2.conf':
      ensure  => present,
      content => template('apache/apache2.conf.erb'),
      require => Package['apache2'],
      notify  => Service['apache2'];

    '/etc/apache2/mods-available/mpm_prefork.conf':
      ensure  => present,
      content => template('apache/mpm_prefork.conf.erb'),
      require => Package['apache2-mpm-prefork'],
      notify  => Service['apache2'];

    '/etc/apache2/mods-available/remoteip.conf':
      ensure  => present,
      source  => 'puppet:///modules/apache/remoteip.conf',
      require => Package['apache2'],
      notify  => Service['apache2'];
  }

  # modules to enable
  apache::module { 'expires.load':  enable => true }
  apache::module { 'headers.load':  enable => true }
  apache::module { ['remoteip.conf', 'remoteip.load']: enable => true }
  apache::module { 'rewrite.load':  enable => true }

  # modules to disable
  apache::module { 'auth_basic.load':      enable => false }
  apache::module { 'authn_file.load':      enable => false }
  apache::module { 'authz_groupfile.load': enable => false }
  apache::module { 'authz_user.load':      enable => false }
  apache::module { ['autoindex.conf', 'autoindex.load']: enable => false }
  apache::module { ['status.conf', 'status.load']:       enable => false }

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure  => absent,
    require => Package['apache2'],
    notify  => Service['apache2'];
  }
}
