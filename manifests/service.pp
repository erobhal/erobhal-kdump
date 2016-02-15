# == Class: kdump::service
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

class kdump::service (
  $kdump_config_file    = $kdump::kdump_config_file,
  $kdump_sysconfig_file = $kdump::kdump_sysconfig_file,
  $kdump_package        = $kdump::kdump_package,
  $kdump_service        = $kdump::kdump_service,
  $kdump_service_ensure = $kdump::kdump_service_ensure,
  $kdump_service_enable = $kdump::kdump_service_enable,
  $path                 = $kdump::path,
  $nfs                  = $kdump::nfs,
)
{
  if $kdump_service_enable {
    if $nfs != undef {
      $kdump_service_require = [ Package[$kdump_package], File[$path], File[$kdump_config_file], File[$kdump_sysconfig_file], Exec['mount_nfs'] ]
    }
    else {
      $kdump_service_require = [ Package[$kdump_package], File[$path], File[$kdump_config_file], File[$kdump_sysconfig_file] ]
    }
  }

  service { $kdump_service:
    ensure  => $kdump_service_ensure,
    enable  => $kdump_service_enable,
    require => $kdump_service_require,
  }
}
