# == Class: grub2::params
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

class grub2::params {
  $config_template              = 'grub2/grub.erb'
  $all_cmdline_linux_extra      = hiera_array('grub2::cmdline_linux_extra',[])

  if defined('kdump') {
    include kdump
    $cmdline_linux_crashkernel    = $kdump::grub2_crashkernel
  }

  if ($::operatingsystem == 'RedHat' and $::operatingsystemmajrelease == '7') {
    $cmdline_linux_base   = 'rd.lvm.lv=sysvg/lv_swap biosdevname=0 rd.lvm.lv=sysvg/lv_root rhgb quiet'
    $timeout              = '5'
    $default              = 'saved'
    $terminal_output      = 'console'
    $disable_recovery     = 'true'
    $disable_submenu      = 'true'
  }
}

