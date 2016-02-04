# == Class: kdump::params
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

class kdump::params {
  $enabled              = true
  $config_template      = 'kdump/kdump.erb'
  $sysconfig_template   = 'kdump/sysconfig_kdump.erb'
  $memlimit_mb          = '2048'

  if ($::operatingsystem == 'RedHat' and $::operatingsystemmajrelease == '7') {

    $path                     = '/var/crash'
    $core_collector           = 'makedumpfile -d 17 -c'
    $crashkernel              = 'auto'
    $nfs                      = undef
    $nfs_mountpoint           = undef
    $nfs_options              = undef
    $ssh                      = undef
    $sshkey                   = '/root/.ssh/kdump_id_rsa'
    $kdump_pre                = undef
    $kdump_post               = undef
    $extra_modules            = undef
    $default                  = 'dump_to_root_fs'
    $mkdumprd_args            = undef
    $kdump_kernelver          = undef
    $kdump_commandline        = undef
    $kdump_commandline_append = 'irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off udev.children-max=2 panic=10 rootflags=nofail acpi_no_memhotplug'
    $kexec_args               = undef
    $kdump_bootdir            = undef
    $kdump_img                = 'vmlinuz'
    $kdump_img_ext            = undef
  }
}

