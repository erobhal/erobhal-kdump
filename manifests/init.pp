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

  # Parameter sanitation
  if is_string($enabled) {
    if $enabled =~ /(?i:true|false)/ {
      $_enabled = str2bool($enabled)
    }
  }
  else {
    $_enabled = $enabled
  }

  # Parameter input validation
  #

  # Mandatory parameters
  unless $_enabled != undef and is_bool($_enabled) {
    fail('Parameter enabled has wrong input type. It is mandatory and should be boolean.')
  }
  unless $config_template != undef and is_string($config_template) {
    fail('Parameter config_template has wrong input type. It is mandatory and should be string.')
  }
  unless $sysconfig_template != undef and is_string($sysconfig_template) {
    fail('Parameter sysconfig_template has wrong input type. It is mandatory and should be string.')
  }
  unless $memlimit_mb != undef and is_numeric($memlimit_mb) {
    fail('Parameter memlimit_mb has wrong input type. It is mandatory and should be numeric.')
  }
  unless $path != undef and is_absolute_path($path) {
    fail('Parameter path has wrong input type. It is mandatory and should be absolute path.')
  }
  unless $crashkernel != undef and is_string($crashkernel) {
    fail('Parameter crashkernel has wrong input type. It is mandatory and should be string.')
  }

  # Optional parameters
  unless $core_collector == undef or is_string($core_collector) {
    fail('Parameter core_collector has wrong input type. Should be string.')
  }
  unless $nfs == undef or is_string($nfs) {
    fail('Parameter nfs has wrong input type. Should be string.')
  }
  unless $nfs_mountpoint == undef or is_absolute_path($nfs_mountpoint) {
    fail('Parameter nfs_mountpoint has wrong input type. Should be absolute path.')
  }
  unless $nfs_options == undef or is_string($nfs_options) {
    fail('Parameter nfs_options has wrong input type. Should be string.')
  }
  unless $ssh == undef or is_string($ssh) {
    fail('Parameter ssh has wrong input type. Should be string.')
  }
  unless $sshkey == undef or is_absolute_path($sshkey) {
    fail('Parameter sshkey has wrong input type. Should be string.')
  }
  unless $kdump_pre == undef or is_string($kdump_pre) {
    fail('Parameter kdump_pre has wrong input type. Should be string.')
  }
  unless $kdump_post == undef or is_string($kdump_post) {
    fail('Parameter kdump_post has wrong input type. Should be string.')
  }
  unless $extra_modules == undef or is_string($extra_modules) {
    fail('Parameter extra_modules has wrong input type. Should be string.')
  }
  unless $default == undef or is_string($default) {
    fail('Parameter default has wrong input type. Should be string.')
  }
  unless $mkdumprd_args == undef or is_string($mkdumprd_args) {
    fail('Parameter mkdumprd_args has wrong input type. Should be string.')
  }
  unless $kdump_kernelver == undef or is_string($kdump_kernelver) {
    fail('Parameter kdump_kernelver has wrong input type. Should be string.')
  }
  unless $kdump_commandline == undef or is_string($kdump_commandline) {
    fail('Parameter kdump_commandline has wrong input type. Should be string.')
  }
  unless $kdump_commandline_append == undef or is_string($kdump_commandline_append) {
    fail('Parameter kdump_commandline_append has wrong input type. Should be string.')
  }
  unless $kexec_args == undef or is_string($kexec_args) {
    fail('Parameter kexec_args has wrong input type. Should be string.')
  }
  unless $kdump_bootdir == undef or is_absolute_path($kdump_bootdir) {
    fail('Parameter kdump_bootdir has wrong input type. Should be absolute path.')
  }
  unless $kdump_img == undef or is_string($kdump_img) {
    fail('Parameter kdump_img has wrong input type. Should be string.')
  }
  unless $kdump_img_ext == undef or is_string($kdump_img_ext) {
    fail('Parameter kdump_img_ext has wrong input type. Should be string.')
  }
    


  # This class needs the grub2 class to handle grub crashkernel parameter
  require grub2

  # RHEL 7
  if $::operatingsystem == 'RedHat' and $::operatingsystemmajrelease == '7' {

    # Only configure kdump on systems with specified memory or more
    if $::memorysize_mb >= $memlimit_mb and $_enabled == true {

      $kdump_ensure      = 'present'
      $grub2_crashkernel = $crashkernel

      if $nfs != undef {
        include kdump::setup::nfs
      }
      else {
        include kdump::setup::local
      }

      if $nfs != undef {
        include kdump::service::nfs
      }
      else {
        include kdump::service::local
      }

    } else {

      $kdump_ensure      = 'absent'
      $grub2_crashkernel = undef

      service { 'kdump':
        ensure  => stopped,
      }


    }

    package { 'kexec-tools':
      ensure  => $kdump_ensure,
    }

    file { '/etc/kdump.conf':
      ensure  => $kdump_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($config_template),
      require => Package['kexec-tools'],
      notify  => Service['kdump'],
    }

    file { '/etc/sysconfig/kdump':
      ensure  => $kdump_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($sysconfig_template),
      require => Package['kexec-tools'],
      notify  => Service['kdump'],
    }

  } else {
    notify {"This kdump module supports RedHat 7, you are running ${::operatingsystem} ${::operatingsystemmajrelease}":}
  }

}
