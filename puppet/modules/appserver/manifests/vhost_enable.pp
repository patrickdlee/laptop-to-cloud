# == Define: vhost_enable
#
# Enables an Apache virtual host
#
define appserver::vhost_enable() {
  file {
    "/etc/apache2/sites-enabled/${name}.conf":
      ensure  => link,
      target  => "/etc/apache2/sites-available/${name}.conf",
      require => File["/etc/apache2/sites-available/${name}.conf"],
      notify  => Service['apache2'];
  }
}
