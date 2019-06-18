  # radarr
#
# Main class, includes all other classes.

class radarr (
  Enum[
    'present',
    'absent',
    'latest',
    'installed'
  ]	  $package_ensure         = 'installed',

  Boolean $package_manage   = true,
  Array   $package_name     = [ 'mono-core', 'mono-devel', 'mono-locale-extras', 'curl', 'mediainfo' ],
  Boolean $epel_manage      = true,
  Boolean $service_enable   = true,
  Enum[
    'stopped',
    'running'
  ]	  $service_ensure   = running,
  Boolean $service_manage   = true,
  String  $service_name     = radarr,
  Boolean $service_hasstatus  = true,
  Boolean $service_hasrestart = true,
  Boolean $install_latest   = true,
  String  $radarr_install_path  = '/opt/radarr',
  String  $radarr_download_url  = 'https://github.com/Radarr/Radarr/archive/v0.2.0.2.tar.gz',

) {

  contain radarr::install
  contain radarr::config
  contain radarr::service

  Class['::radarr::install']
  -> Class['::radarr::config']
  ~> Class['::radarr::service']
}
