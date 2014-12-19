# == Class: php
#
# Installs PHP5 and necessary modules. Sets config files.
#
class php {
  package { 'php5':                ensure => present }
  package { 'php5-curl':           ensure => present }
  package { 'php5-dev':            ensure => present }
  package { 'php5-gd':             ensure => present }
  package { 'php5-imagick':        ensure => present }
  package { 'php5-mcrypt':         ensure => present }
  package { 'php5-memcache':       ensure => present }
  package { 'php5-mysql':          ensure => present }
  package { 'php5-pspell':         ensure => present }
  package { 'php5-sqlite':         ensure => present }
  package { 'php5-tidy':           ensure => present }
  package { 'php5-xdebug':         ensure => present }
  package { 'php5-xmlrpc':         ensure => present }
  package { 'php5-xsl':            ensure => present }
  package { 'libapache2-mod-php5': ensure => present }

  file { '/etc/php5/apache2/php.ini':
    source  => 'puppet:///modules/php/apache2-php.ini',
    require => Package['php5', 'libapache2-mod-php5'];
  }


  if $::instanceenv != 'development' {
    package { 'php5-apcu': ensure => present }

    file { '/etc/php5/mods-available/apcu.ini':
      source  => 'puppet:///modules/php/apcu.ini',
      require => Package['php5-apcu'],
      notify  => Service['apache2'];
    }
  }

  package { 'php5-cli': ensure => present }

  file { '/etc/php5/cli/php.ini':
    source  => 'puppet:///modules/php/cli-php.ini',
    require => Package['php5-cli'];
  }
}
