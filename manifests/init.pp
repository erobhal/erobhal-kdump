# == Class: kdump
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

class kdump (
  $enabled                      = $kdump::params::enabled,
  $config_template              = $kdump::params::config_template,
  $sysconfig_template           = $kdump::params::sysconfig_template,
  $memlimit_mb                  = $kdump::params::memlimit_mb,
  $path                         = $kdump::params::path,
  $core_collector               = $kdump::params::core_collector,
  $crashkernel                  = $kdump::params::crashkernel,
  $nfs                          = $kdump::params::nfs,
  $nfs_mountpoint               = $kdump::params::nfs_mountpoint,
  $nfs_options                  = $kdump::params::nfs_options,
  $ssh                          = $kdump::params::ssh,
  $sshkey                       = $kdump::params::sshkey,
  $kdump_pre                    = $kdump::params::kdump_pre,
  $kdump_post                   = $kdump::params::kdump_post,
  $extra_modules                = $kdump::params::extra_modules,
  $default                      = $kdump::params::default,
  $mkdumprd_args                = $kdump::params::mkdumprd_args,
  $kdump_kernelver              = $kdump::params::kdump_kernelver,
  $kdump_commandline            = $kdump::params::kdump_commandline,
  $kdump_commandline_append     = $kdump::params::kdump_commandline_append,
  $kexec_args                   = $kdump::params::kexec_args,
  $kdump_bootdir                = $kdump::params::kdump_bootdir,
  $kdump_img                    = $kdump::params::kdump_img,
  $kdump_img_ext                = $kdump::params::kdump_img_ext,
) inherits kdump::params {

  # This class needs the grub2 class to handle grub crashkernel parameter
  require grub2

  # RHEL 7
  if $::operatingsystem == 'RedHat' and $::operatingsystemmajrelease == '7' {

    # Only configure kdump on systems with specified memory or more
    if $::memorysize_mb >= $memlimit_mb and $enabled == true {

      $grub2_crashkernel= $crashkernel

      if $nfs != undef {
        include kdump::install::dumpnfs
      }
      else {
        include kdump::install::dumplocal
      }

      if $nfs != undef {
        include kdump::service::dumpnfs
      }
      else {
        include kdump::service::dumplocal
      }

      file { '/etc/kdump.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template($config_template),
        require => Package['kexec-tools'],
        notify  => Service['kdump'],
      }

      file { '/etc/sysconfig/kdump':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template($sysconfig_template),
        require => Package['kexec-tools'],
        notify  => Service['kdump'],
      }

    } else {

      $grub2_crashkernel = undef

      package { 'kexec-tools':
        ensure  => absent,
      }

      file { '/etc/kdump.conf':
        ensure  => absent,
      }

      file { '/etc/sysconfig/kdump':
        ensure  => absent,
      }

    }

  } else {
    notify {"This kdump module supports RedHat 7, you are running ${::operatingsystem} ${::operatingsystemmajrelease}":}
  }

}
