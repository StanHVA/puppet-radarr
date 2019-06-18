# @summary
#   This class handles radarr packages.
#
# @api private
#
class radarr::install {

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

  if $radarr::install_latest {
    $download_url = inline_template("<%= `curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4` %>")
  }
  else {
    $download_url = $radarr::download_url
  }

  exec { 'download tarball':
    cwd     => "${radarr::radarr_install_path}/../",
    command => "/usr/bin/curl -o /tmp/radarr.tar.gz -s ${download_url}",
    unless  => "/usr/bin/test -f ${radarr::radarr_install_path}",
    timeout => 600,
    before  => File["${gitlab::git_home}/.gitlab_database_done"],
  }
  -> exec { 'untar':
    command => "/bin/tar -xvf /tmp/radarr.tar.gz -C ${puppet::puppet_install_path}",
    require => File['/tmp/radarr.tar.gz'],
    unless  => "/usr/bin/test -f ${radarr::radarr_install_path}",
  }
  -> exec { 'clean':
    command => '/usr/bin/rm /tmp/radarr.tar.gz',
    unless  => '/usr/bin/test -f /tmp/radarr.tar.gz',
  }

  file { "{${radarr::radarr_install_path}}" :
    ensure => 'directory',
    owner  => 'radarr',
    group  => 'radarr',
    mode   => '0755',
  }

  file { "{${radarr::radarr_install_path}}/data" :
    ensure => 'directory',
    owner  => 'radarr',
    group  => 'radarr',
    mode   => '0755',
  }

}
