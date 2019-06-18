  # radarr
#
# Main class, includes all other classes.

class radarr () {
  # defaults for tinker and panic are different, when running on virtual machines

  contain ntp::install
  contain ntp::config
  contain ntp::service

  Class['::ntp::install']
  -> Class['::ntp::config']
  ~> Class['::ntp::service']
}
