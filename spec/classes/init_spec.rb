require 'spec_helper'

describe 'kdump' do

  describe 'on RedHat 7 with memory >= 2048 MB' do
    let(:facts) { {
      :operatingsystem => 'RedHat',
      :operatingsystemmajrelease => '7',
      :memorysize_mb => '2048',
    } }

    context 'default params on RedHat 7' do
      it do
        should contain_file('/etc/kdump.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
        }).with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#
#
path /var/crash
core_collector makedumpfile -d 17 -c
default dump_to_root_fs
}
       ).that_notifies('Service[kdump]')

      end

      it do
        should contain_file('/etc/sysconfig/kdump').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
        }).with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#
#
#
KDUMP_COMMANDLINE_APPEND="irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off udev.children-max=2 panic=10 rootflags=nofail acpi_no_memhotplug"
KDUMP_IMG="vmlinuz"
}
       ).that_notifies('Service[kdump]')

      end

      it do
        should contain_file('/var/crash').with({
          'ensure' => 'directory',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0750',
        })
      end

      it do
        should contain_service('kdump').with({
          'ensure' => 'running',
          'enable' => 'true',
          'require' => [
            'Package[kexec-tools]',
            'File[/var/crash]',
            'File[/etc/kdump.conf]',
            'File[/etc/sysconfig/kdump]',
           ]
        })
      end

    end

    context 'modified params on RedHat 7' do
    let(:params) { {
      :path => '/local/crash',
      :core_collector => '*core_collector*',
      :crashkernel => '*crashkernel*',
      :ssh => '*ssh*',
      :sshkey => '/local/ssh',
      :kdump_pre => '*kdump_pre*',
      :kdump_post => '*kdump_post*',
      :extra_modules => '*extra_modules*',
      :default => '*default*',
      :mkdumprd_args => '*mkdumprd_args*',
      :kdump_kernelver => '*kdump_kernelver*',
      :kdump_commandline => '*kdump_commandline*',
      :kdump_commandline_append => '*kdump_commandline_append*',
      :kexec_args => '*kexec_args*',
      :kdump_bootdir => '/boot',
      :kdump_img => '*kdump_img*',
      :kdump_img_ext => '*kdump_img_ext*',
      :nfs => :undef,
      :nfs_mountpoint => :undef,
      :nfs_options => :undef,
    } }

      it do
        should contain_file('/local/crash').with({
          'ensure' => 'directory',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0750',
        })
      end

      it do
        should contain_file('/etc/kdump.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
        }).with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#
#
ssh *ssh*
sshkey /local/ssh
path /local/crash
core_collector *core_collector*
kdump_pre *kdump_pre*
kdump_post *kdump_post*
extra_modules *extra_modules*
default *default*
}
       ).that_notifies('Service[kdump]')

      end

      it do
        should contain_file('/etc/sysconfig/kdump').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
        }).with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#
#
#
KDUMP_KERNELVER="*kdump_kernelver*"
KDUMP_COMMANDLINE="*kdump_commandline*"
KDUMP_COMMANDLINE_APPEND="*kdump_commandline_append*"
KEXEC_ARGS="*kexec_args*"
KDUMP_BOOTDIR="/boot"
KDUMP_IMG="*kdump_img*"
KDUMP_IMG_EXT="*kdump_img_ext*"
MKDUMPRD_ARGS="*mkdumprd_args*"
}
       ).that_notifies('Service[kdump]')

      end

      it do
        should contain_service('kdump').with({
          'ensure' => 'running',
          'enable' => 'true',
          'require' => [
            'Package[kexec-tools]',
            'File[/local/crash]',
            'File[/etc/kdump.conf]',
            'File[/etc/sysconfig/kdump]',
           ]
        })
      end

    end

    context 'nfs mount on RedHat 7' do
    let(:params) { {
      :path => '/crash',
      :nfs => 'example.com:/share',
      :nfs_mountpoint => '/local/mnt',
      :nfs_options => 'ro',
      :core_collector => :undef,
      :crashkernel => :undef,
      :ssh => :undef,
      :sshkey => :undef,
      :kdump_pre => :undef,
      :kdump_post => :undef,
      :extra_modules => :undef,
      :default => :undef,
    } }

      it do
        should contain_file('/etc/kdump.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
        }).with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#
#
nfs example.com:/share
path /crash
core_collector makedumpfile -d 17 -c
default dump_to_root_fs
}
       ).that_notifies('Service[kdump]')

      end

      it do
        should contain_file('/local/mnt').with({
          'ensure' => 'directory',
        })
      end

      it do
        should contain_exec('mount_nfs').with({
          'command' => 'mount -t nfs -o ro example.com:/share /local/mnt',
          'path' => ['/usr/sbin','/usr/bin','/bin'],
          'onlyif' => "test -z \"`mount | grep 'on /local/mnt '`\"",
          'require' => 'File[/local/mnt]',
        }).that_notifies('Exec[make_directory]')
      end

      it do
        should contain_exec('make_directory').with({
          'command' => 'umask 0007; mkdir -p /local/mnt//crash',
          'path' => ['/usr/sbin','/usr/bin','/bin'],
          'onlyif' => ["test -n \"`mount | grep 'on /local/mnt '`\"",
                       "test -z \"`ls -d /local/mnt//crash 2>/dev/null`\""], 
          'require' => ['File[/local/mnt]', 'Exec[mount_nfs]']
        })
      end

      it do
        should contain_service('kdump').with({
          'ensure' => 'running',
          'enable' => 'true',
          'require' => [
            'Package[kexec-tools]',
            'File[/crash]',
            'File[/etc/kdump.conf]',
            'File[/etc/sysconfig/kdump]',
            'Exec[mount_nfs]',
           ]
        })
      end

    end

    it do
      should contain_package('kexec-tools').with({
        'ensure' => 'present',
      })
    end


    # Input validation
    context 'sending wrong type to parameter :enabled' do
    let(:params) { {
      :enabled => 'yes',
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :config_template' do
    let(:params) { {
      :config_template => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :sysconfig_template' do
    let(:params) { {
      :sysconfig_template => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :memlimit_mb' do
    let(:params) { {
      :memlimit_mb => 'thirty',
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :path' do
    let(:params) { {
      :path => 'a/path',
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :core_collector' do
    let(:params) { {
      :core_collector => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :crashkernel' do
    let(:params) { {
      :crashkernel => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :nfs' do
    let(:params) { {
      :nfs => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :nfs_mountpoint' do
    let(:params) { {
      :nfs_mountpoint => 'a/path',
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :nfs_options' do
    let(:params) { {
      :nfs_options => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :ssh' do
    let(:params) { {
      :ssh => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :sshkey' do
    let(:params) { {
      :sshkey => 'a/path',
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_pre' do
    let(:params) { {
      :kdump_pre => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_post' do
    let(:params) { {
      :kdump_post => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :extra_modules' do
    let(:params) { {
      :extra_modules => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :default' do
    let(:params) { {
      :default => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :mkdumprd_args' do
    let(:params) { {
      :mkdumprd_args => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_kernelver' do
    let(:params) { {
      :kdump_kernelver => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_commandline' do
    let(:params) { {
      :kdump_commandline => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_commandline_append' do
    let(:params) { {
      :kdump_commandline_append => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kexec_args' do
    let(:params) { {
      :kexec_args => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_bootdir' do
    let(:params) { {
      :kdump_bootdir => 'a/path',
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_img' do
    let(:params) { {
      :kdump_img => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_img_ext' do
    let(:params) { {
      :kdump_img_ext => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end

    it { should compile.with_all_deps }

  end

  describe 'on RedHat 7 with memory < 2048 MB' do
    let(:facts) { {
      :operatingsystem => 'RedHat',
      :operatingsystemmajrelease => '7',
      :memorysize_mb => '2047',
    } }

    it do
      should contain_file('/etc/kdump.conf').with({
        'ensure' => 'absent',
      })
    end

    it do
      should contain_file('/etc/sysconfig/kdump').with({
        'ensure' => 'absent',
      })
    end

    it do
      should contain_package('kexec-tools').with({
        'ensure' => 'absent',
      })
    end

    it { should compile.with_all_deps }

  end

  describe 'not on RedHat 7' do
    let(:facts) { {
      :operatingsystem => 'WrongOS',
      :operatingsystemmajrelease => '0',
    } }
    let(:params) { {
      :path => '/local/crash',
      :crashkernel => 'auto',
    } }
    it { should contain_notify('This kdump module supports RedHat 7, you are running WrongOS 0')}
  end

end

