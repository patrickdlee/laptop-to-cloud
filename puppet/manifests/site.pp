include stdlib

$userdata = parsejson($ec2_userdata)

if has_key($userdata, 'role') {
  $instancerole = $userdata['role']
} else {
  fail('Missing instancerole.')
}

if has_key($userdata, 'env') {
  $instanceenv = $userdata['env']
} else {
  fail('Missing instanceenv.')
}

if $::instanceenv == 'development' {
  $user = 'vagrant'
} else {
  $user = 'ubuntu'
}

stage { 'pre': before => Stage['main'] }

class { 'baseconfig':
  stage => 'pre',
  user  => $user
}

File {
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644'
}

case $::instancerole {
  example: {
    include apache, php, appserver
  }

  default: {
    fail('Invalid instancerole.')
  }
}
