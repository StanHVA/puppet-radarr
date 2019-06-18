# @summary
#   This class handles the radarr service.
#
# @api private
#
class radarr::service {

  if $radarr::service_manage == true {

  file { '/etc/systemd/system/radarr.service':
    ensure  => file,
    content => template('radarr/radarr.service.erb'),
  }

    service { 'radarr':
      ensure     => $radarr::service_ensure,
      enable     => $radarr::service_enable,
      name       => $radarr::service_name,
      hasstatus  => $radarr::service_hasstatus,
      hasrestart => $radarr::service_hasrestart,
    }
  }

}
