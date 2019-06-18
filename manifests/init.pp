  # radarr
#
# Main class, includes all other classes.

class radarr () {

  contain ntp::install
  contain ntp::config
  contain ntp::service

  Class['::ntp::install']
  -> Class['::ntp::config']
  ~> Class['::ntp::service']
}
