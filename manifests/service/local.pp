# == Class: kdump::service::local
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

class kdump::service::local (
  $path = $kdump::path,
)
{
  include kdump

  service { 'kdump':
    ensure  => running,
    enable  => true,
    require => [ Package['kexec-tools'], File[$path], File['/etc/kdump.conf'], File['/etc/sysconfig/kdump'] ],
  }
}

