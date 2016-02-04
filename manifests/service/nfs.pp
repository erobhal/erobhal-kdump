# == Class: kdump::service::nfs
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

class kdump::service::nfs inherits kdump {
  service { 'kdump':
    ensure  => running,
    enable  => true,
    require => [ Package['kexec-tools'], File['/etc/kdump.conf'], File['/etc/sysconfig/kdump'], Exec['mount_nfs'] ],
  }
}
