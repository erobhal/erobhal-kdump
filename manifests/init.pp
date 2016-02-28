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
  $kdump_config_file            = $kdump::params::kdump_config_file,
  $kdump_sysconfig_file         = $kdump::params::kdump_sysconfig_file,
  $kdump_package                = $kdump::params::kdump_package,
  $kdump_service                = $kdump::params::kdump_service,
  $config_template              = $kdump::params::config_template,
  $sysconfig_template           = $kdump::params::sysconfig_template,
  $memlimit_mb                  = $kdump::params::memlimit_mb,
  $path                         = $kdump::params::path,
  $core_collector               = $kdump::params::core_collector,
  $crashkernel                  = $kdump::params::crashkernel,
  $nfs                          = $kdump::params::nfs,
  $nfs_mountpoint               = $kdump::params::nfs_mountpoint,
  $nfs_options                  = $kdump::params::nfs_options,
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
 

  case $::operatingsystem {
    'RedHat': { # List supported OS here for sanitation/validation to run

      # Parameter sanitation
      if $enabled != undef and is_string($enabled) and $enabled =~ /(?i:true|false)/ {
        $_enabled = str2bool($enabled)
      }
      else {
        $_enabled = $enabled
      }

      # Parameter input validation
      #
      include kdump::params::verify
    }
    default: {
      # Not on a supported OS
    }
  }

  # RHEL 7
  if $::operatingsystem == 'RedHat' and $::operatingsystemmajrelease == '7' {

    # Only configure kdump on systems with specified memory or more
    if $::memorysize_mb >= $memlimit_mb and $_enabled == true {

      $kdump_ensure         = 'present'
      $kdump_service_ensure = 'running'
      $kdump_service_enable = true
      $grub2_crashkernel    = $crashkernel

      include kdump::setup

    } else {

      $kdump_ensure         = 'absent'
      $kdump_service_ensure = 'stopped'
      $kdump_service_enable = false
      $grub2_crashkernel    = undef

    }

    include kdump::service

    package { $kdump_package:
      ensure  => $kdump_ensure,
    }

    file { $kdump_config_file:
      ensure  => $kdump_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($config_template),
      require => Package[$kdump_package],
      notify  => Service[$kdump_service],
    }

    file { $kdump_sysconfig_file:
      ensure  => $kdump_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($sysconfig_template),
      require => Package[$kdump_package],
      notify  => Service[$kdump_service],
    }

  } else {
    notify {"This kdump module supports RedHat 7, you are running ${::operatingsystem} ${::operatingsystemmajrelease}":}
  }

}
