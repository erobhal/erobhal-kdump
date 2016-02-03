# == Class: kdump::install::dumpnfs
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

class kdump::install::dumpnfs inherits kdump {
  package { 'kexec-tools':
    ensure  => present,
  }

  # Local path is needed if default action dump_to_root_fs is set
  file { $kdump::path:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  file { $kdump::nfs_mountpoint:
    ensure => 'directory',
    notify => Exec['mount_nfs'],
  }

  if $kdump::nfs_options != undef {
    exec { 'mount_nfs':
      command => "mount -t nfs -o ${kdump::nfs_options} ${kdump::nfs} ${kdump::nfs_mountpoint}",
      path    => ['/usr/sbin','/usr/bin','/bin'],
      onlyif  => "test -z \"`mount | grep 'on ${kdump::nfs_mountpoint} '`\"",
      require => File[$kdump::nfs_mountpoint],
      notify  => Exec['make_directory'],
    }
  }
  else {
    exec { 'mount_nfs':
      command => "mount -t nfs ${kdump::nfs} ${kdump::nfs_mountpoint}",
      path    => ['/usr/sbin','/usr/bin','/bin'],
      onlyif  => "test -z \"`mount | grep 'on ${kdump::nfs_mountpoint} '`\"",
      require => File[$kdump::nfs_mountpoint],
      notify  => Exec['make_directory'],
    }
  }

  exec { 'make_directory':
    command => "umask 0007; mkdir -p ${kdump::nfs_mountpoint}/${kdump::path}",
    path    => ['/usr/sbin','/usr/bin','/bin'],
    onlyif  => [ "test -n \"`mount | grep 'on ${kdump::nfs_mountpoint} '`\"",
                "test -z \"`ls -d ${kdump::nfs_mountpoint}/${kdump::path} 2>/dev/null`\"" ],
    require => [ File[$kdump::nfs_mountpoint], Exec['mount_nfs']],
  }
}
