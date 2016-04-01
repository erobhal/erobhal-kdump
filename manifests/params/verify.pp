# == Class: kdump::params::verify
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

class kdump::params::verify (
  $enabled                      = $kdump::_enabled,
  $kdump_config_file            = $kdump::kdump_config_file,
  $kdump_sysconfig_file         = $kdump::kdump_sysconfig_file,
  $kdump_package                = $kdump::kdump_package,
  $kdump_service                = $kdump::kdump_service,
  $config_template              = $kdump::config_template,
  $sysconfig_template           = $kdump::sysconfig_template,
  $memlimit_mb                  = $kdump::memlimit_mb,
  $path                         = $kdump::path,
  $core_collector               = $kdump::core_collector,
  $crashkernel                  = $kdump::crashkernel,
  $nfs                          = $kdump::nfs,
  $nfs_mountpoint               = $kdump::nfs_mountpoint,
  $nfs_options                  = $kdump::nfs_options,
  $kdump_pre                    = $kdump::kdump_pre,
  $kdump_post                   = $kdump::kdump_post,
  $extra_modules                = $kdump::extra_modules,
  $default                      = $kdump::default,
  $mkdumprd_args                = $kdump::mkdumprd_args,
  $kdump_kernelver              = $kdump::kdump_kernelver,
  $kdump_commandline            = $kdump::kdump_commandline,
  $kdump_commandline_append     = $kdump::kdump_commandline_append,
  $kexec_args                   = $kdump::kexec_args,
  $kdump_bootdir                = $kdump::kdump_bootdir,
  $kdump_img                    = $kdump::kdump_img,
  $kdump_img_ext                = $kdump::kdump_img_ext,
) inherits kdump {

  # Mandatory parameters
  unless $enabled != undef and is_bool($enabled) {
    fail('Parameter enabled has wrong input type. It is mandatory and should be boolean.')
  }
  unless $config_template != undef and is_string($config_template) {
    fail('Parameter config_template has wrong input type. It is mandatory and should be string.')
  }
  unless $sysconfig_template != undef and is_string($sysconfig_template) {
    fail('Parameter sysconfig_template has wrong input type. It is mandatory and should be string.')
  }
  unless $kdump_config_file != undef and is_string($kdump_config_file) {
    fail('Parameter kdump_config_file has wrong input type. It is mandatory and should be string.')
  }
  unless $kdump_sysconfig_file != undef and is_string($kdump_sysconfig_file) {
    fail('Parameter kdump_sysconfig_file has wrong input type. It is mandatory and should be string.')
  }
  unless $kdump_package != undef and is_string($kdump_package) {
    fail('Parameter kdump_package has wrong input type. It is mandatory and should be string.')
  }
  unless $kdump_service != undef and is_string($kdump_service) {
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

  # Validate dependencies
  if $nfs != undef and $nfs_mountpoint == undef {
    fail('Parameter nfs_moutpoint is required when nfs is set.')
  }
      
}

