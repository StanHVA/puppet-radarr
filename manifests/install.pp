# @summary
#   This class handles radarr packages.
#
# @api private
#
class radarr::install {

  group { 'radarr':
        ensure => 'present',
  }

  user { 'radarr':
    ensure  => 'present',
    home    => '/opt/radarr',
    password => '!!',
    password_max_age    => '99999',
    password_min_age    => '0',
    shell               => '/bin/bash',
    groups => [ 'radarr' ],
  }

  if $radarr::package_manage {

    if $radarr::epel_manage {
      package { 'epel-release':
      ensure => 'installed',
    }
    }

    package { $radarr::package_name:
      ensure => $radarr::package_ensure,
    }
  }

  $download_url = generate('/bin/sh', '-c', '/usr/bin/curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \'"\' -f 4')

  file { "${radarr::radarr_install_path}" :
    ensure => 'directory',
    owner  => 'radarr',
    group  => 'radarr',
    mode   => '0755',
  }
  -> file { "${radarr::radarr_install_path}/data" :
    ensure => 'directory',
    owner  => 'radarr',
    group  => 'radarr',
    mode   => '0755',
  }
  -> exec { 'download tarball':
    command => "/usr/bin/curl -o /tmp/radarr.tar.gz -sL ${download_url}",
    timeout => 600,
  }
  -> exec { 'untar':
    command => "/bin/tar -xzf /tmp/radarr.tar.gz --strip-components=1 -C ${radarr::radarr_install_path}",
  }
  -> exec { 'clean':
    command => '/usr/bin/rm /tmp/radarr.tar.gz',
  }
  -> exec { 'chown':
    command => "/usr/bin/chown radarr:radarr -R ${radarr::radarr_install_path}",
  }
}