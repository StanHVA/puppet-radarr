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
    shell => '/sbin/nologin',
    groups => 'radarr'
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
    onlyif => '/usr/bin/test -e ${radarr::radarr_install_path}/Radarr.exe',
    timeout => 600,
  }
  -> exec { 'untar':
    command => "/bin/tar -xzf /tmp/radarr.tar.gz --strip-components=1 -C ${radarr::radarr_install_path}",
    onlyif => '/usr/bin/test -e ${radarr::radarr_install_path}/Radarr.exe',
  }
  -> exec { 'clean':
    command => '/usr/bin/rm /tmp/radarr.tar.gz',
    onlyif => '/usr/bin/test -e ${radarr::radarr_install_path}/Radarr.exe',
  }
  -> exec { 'chown':
    command => "/usr/bin/chown radarr:radarr -R ${radarr::radarr_install_path}",
  }
}