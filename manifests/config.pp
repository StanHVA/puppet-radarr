# @summary
#   This class handles the configuration file.
#
# @api private
#
class ntp::config {

  notify { 'some-notify':
    name    => 'super',
    message => 'in config',
  }
}
