# == Class: kdump::setup::nfs
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

class kdump::setup::nfs (
  $path  = $kdump::path,
  $nfs            = $kdump::nfs,
  $nfs_mountpoint = $kdump::nfs_mountpoint,
  $nfs_options    = $kdump::nfs_options,
)
{

  include kdump

  file { $path:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  file { $nfs_mountpoint:
    ensure => 'directory',
    notify => Exec['mount_nfs'],
  }

  if $nfs_options != undef {
    exec { 'mount_nfs':
      command => "mount -t nfs -o ${nfs_options} ${nfs} ${nfs_mountpoint}",
      path    => ['/usr/sbin','/usr/bin','/bin'],
      onlyif  => "test -z \"`mount | grep 'on ${nfs_mountpoint} '`\"",
      require => File[$nfs_mountpoint],
      notify  => Exec['make_directory'],
    }
  }
  else {
    exec { 'mount_nfs':
      command => "mount -t nfs ${nfs} ${nfs_mountpoint}",
      path    => ['/usr/sbin','/usr/bin','/bin'],
      onlyif  => "test -z \"`mount | grep 'on ${nfs_mountpoint} '`\"",
      require => File[$nfs_mountpoint],
      notify  => Exec['make_directory'],
    }
  }

  exec { 'make_directory':
    command => "umask 0007; mkdir -p ${nfs_mountpoint}/${path}",
    path    => ['/usr/sbin','/usr/bin','/bin'],
    onlyif  => [ "test -n \"`mount | grep 'on ${nfs_mountpoint} '`\"",
                "test -z \"`ls -d ${nfs_mountpoint}/${path} 2>/dev/null`\"" ],
    require => [ File[$nfs_mountpoint], Exec['mount_nfs']],
  }
}
