# == Class: kdump::install::dumplocal
#
# See README for documentation
#
# === Authors
#
# Robert Hallgren <robert.e.hallgren@ericsson.com>
#
# === Copyright
#
# Copyright 2016 Ericsson AB, unless otherwise noted.
#

class kdump::install::dumplocal inherits kdump {
  package { 'kexec-tools':
    ensure  => present,
  }

  file { $kdump::path:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }
}

