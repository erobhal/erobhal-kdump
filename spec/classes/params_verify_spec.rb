require 'spec_helper'

describe 'kdump' do

  describe 'on RedHat 7 with memory >= 2048 MB' do
    let(:facts) { {
      :operatingsystem => 'RedHat',
      :operatingsystemmajrelease => '7',
      :memorysize_mb => '2048',
    } }

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
    context 'sending wrong type to parameter :kdump_config_file' do
    let(:params) { {
      :kdump_config_file => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_sysconfig_file' do
    let(:params) { {
      :kdump_sysconfig_file => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_package' do
    let(:params) { {
      :kdump_package => false,
    } }
      it 'should fail' do
        expect {
          should contain_class('kdump')
        }.to raise_error(Puppet::Error,/wrong input type/)
      end
    end
    context 'sending wrong type to parameter :kdump_service' do
    let(:params) { {
      :kdump_service => false,
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
      :path => false,
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
      :nfs_mountpoint => false,
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
      :kdump_bootdir => false,
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

  end

end

