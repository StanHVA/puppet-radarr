# @summary
#   This class handles the configuration file.
#
# @api private
#
class radarr::config {

  notify { 'some-notify':
    name    => 'super',
    message => 'in config',
  }
}
