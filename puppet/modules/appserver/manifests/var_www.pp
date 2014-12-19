# == Define: var_www
#
# Sets up folders and symlinks in /var/www
#
define appserver::var_www() {
  file {
    "/var/www/${name}":
      ensure  => directory,
      require => Package['apache2'];

    "/var/www/${name}/releases":
      ensure  => directory,
      require => File["/var/www/${name}"];
  }

  # set up symlink to code folder if this is a dev VM
  if $::instanceenv == 'development' {
    file {
      "/var/www/${name}/current":
        ensure  => symlink,
        target  => "/home/vagrant/code/www/${name}",
        require => File["/var/www/${name}"];
    }
  }
}
