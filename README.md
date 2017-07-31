[![Build Status](https://travis-ci.org/erobhal/puppet-module-kdump.svg?branch=master)](https://travis-ci.org/erobhal/puppet-module-kdump)

# erobhal-kdump

This module manages kdump. It needs erobhal-grub2 for management
of the crashkernel boot parameter.

## Supported distributions
- Red Hat 7

## Parameters

#### enabled
 - Whether to activate kdump or not. If the module is run with enabled set
   to false, kdump will be de-activated and uninstalled.
 - **BOOLEAN** : *true*

#### config_template
 - Path to the puppet template to use for /etc/kdump.cfg
 - **STRING** : *'kdump/kdump.erb'*

#### sysconfig_template
 - Path to the puppet template to use for /etc/sysconfig/kdump
 - **STRING** : *'kdump/sysconfig_kdump.erb'*

#### memlimit_mb
 - Memory limit in MB. If the system has less memory than this kdump will
   not be activated.
 - **STRING** : *'2048'*

#### path
 - Path to where the crashdump should be saved.
   NOTE: If on local filesystem the parent directory MUST already exist since
   puppet doesn't create directories recursively.
 - **STRING** : *'/var/crash'*

#### core_collector
 - Set the core collector and it's arguments.
 - **STRING** : *'makedumpfile -d 17 -c'*

#### crashkernel
 - Set the crashkernel boot parameter. This is fetched by erobhal-grub2
   and is included in the OS grub configuration file (/etc/sysconfig/grub).
   on RedHat. 
 - **STRING** : *'auto'*

#### nfs
 - NFS share to where the crashdump should be saved.
   Puppet will try to use $nfs, $nfs_mountpoint and $path to create the mountpoint,
   mount the NFS share and create the directory structure specified in $path
 - **STRING** : *undef*

#### nfs_mountpoint
 - Mountpoint for the NFS share. Mandatory if $nfs is set.
 - **STRING** : *undef*

#### nfs_options
 - Options to be used when mounting the NFS share.
 - **STRING** : *undef*

#### dracut_args
 - Arguments to send to dracut when creating crashkernel bootimage.
   NOTE: When using dracut_args to set up NFS the module doesn't verify that the NFS
   export or the mount point exists. This has to be done outside of this module.
 - **ARRAY** : *undef*

#### kdump_pre
 -  Run a specified executable just before the memory dump process initiates.
 - **STRING** : *undef*

#### kdump_post
 -  Run a specified executable just after the memory dump process terminates
 - **STRING** : *undef*

#### extra_modules
 - Allows you to specify extra kernel modules that you want to be loaded in the kdump initrd.
 - **STRING** : *undef*

#### default
 - Configure a default action when kdump fails to create a core dump at the target location. Valid
   actions are:
 - *dump_to_root_fs* : Attempt to save the core dump to the root file system. This option is especially
                       useful in combination with a network target: if the network target is
                       unreachable, this option configures kdump to save the core dump locally. The
                       system is rebooted afterwards.
 - *reboot*          : Reboot the system, losing the core dump in the process.
 - *halt*            : Halt the system, losing the core dump in the process.
 - *poweroff*        : Power off the system, losing the core dump in the process.
 - *shell*           : Run a shell session from within the initramfs, allowing the user to record the
                       core dump manually.
 - **STRING** : *dump_to_root_fs*

#### mkdumprd_args
 - Arguments to pass to mkdumprd when creating ramdisk images for kdump crash recovery.
 - **STRING** : *undef*

#### kdump_kernelver
 - Kernel version string for the -kdump kernel, such as 2.6.16-5-kdump. If no version is
   specified, then the init script will try to find a kdump kernel with the same version
   number as the running kernel.
 - **STRING** : *undef*

#### kdump_commandline
 - The command line that needs to be passed off to the kdump kernel. This will likely match
   the contents of the grub kernel line. If not specified, the default will be taken from
   /proc/cmdline.
 - **STRING** : *undef*

#### kdump_commandline_append
 - String to be appended to kdump_commandline.
 - **STRING** : *'irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off udev.children-max=2 panic=10 rootflags=nofail acpi_no_memhotplug'*

#### kexec_args
 - TBD
 - **STRING** : *undef*

#### kdump_bootdir
 - TBD
 - **STRING** : *undef*

#### kdump_img
 - TBD
 - **STRING** : *undef*

#### kdump_img_ext
 - TBD
 - **STRING** : *undef*

### Example
```ruby
    class { 'kdump':
      path                  => '/local/crash',
      core_collector        => 'makedumpfile -d 17 -c',
      crashkernel           => 'auto'
    }
```
### Hiera support

This module also supports the configuration of the parameters it exposes
using Hiera. To set the value of `path` to `/var/crash`, you would use:
```yaml
kdump::path: /var/crash
```

Example using NFS:
```yaml
kdump::path: /dump/here
kdump::nfs: mynfsserver.mydoimain.com:/export
kdump::nfs_mountpoint: /mnt/crash
kdump::nfs_options: rw
```

The option dracut_args is a hiera_array where setting can be added at multiple levels in your Hiera files:

Example of using dracut_args to configure NFS:
```yaml
kdump::dracut_args: --mount "mynfsserver.mydoimain.com:/export /mnt/crash nfs defaults"
```

