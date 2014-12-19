# == Class: appserver
#
# Sets up example vhost.
#
class appserver {
  appserver::var_www { 'example': }

  file { '/etc/apache2/sites-available/example.conf':
    ensure  => present,
    content => template('appserver/vhost-example.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'];
  }

  appserver::vhost_enable { 'example': }
}
