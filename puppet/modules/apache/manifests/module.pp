# == Define: module
#
# Enables an Apache module.
#
define apache::module($enable = true) {
  if $enable == true {
    file { "/etc/apache2/mods-enabled/${name}":
      ensure  => link,
      target  => "/etc/apache2/mods-available/${name}",
      require => Package['apache2'],
      notify  => Service['apache2'];
    }
  } else {
    file { "/etc/apache2/mods-enabled/${name}":
      ensure  => absent,
      require => Package['apache2'],
      notify  => Service['apache2'];
    }
  }
}
