# == Class: kdump::setup::local
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

class kdump::setup::local (
  $path  = $kdump::path,
)
{

  include kdump

  file { $path:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

}
