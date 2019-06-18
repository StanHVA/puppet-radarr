  # radarr
#
# Main class, includes all other classes.

class radarr () {

  contain radarr::install
  contain radarr::config
  contain radarr::service

  Class['::radarr::install']
  -> Class['::radarr::config']
  ~> Class['::radarr::service']
}
