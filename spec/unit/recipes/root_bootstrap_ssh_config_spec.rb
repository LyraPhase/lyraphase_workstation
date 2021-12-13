require 'spec_helper'

describe 'lyraphase_workstation::root_bootstrap_ssh_config' do

  let(:root_ssh) { '/var/root/.ssh' }
  let(:root_ssh_config) { '/var/root/.ssh/config' }
  let(:root_ssh_known_hosts) { '/var/root/.ssh/known_hosts' }
  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'

      node.normal['lyraphase_workstation']['root_bootstrap_ssh_config']['identity_file'] = 'identity.brubble'
    end.converge(described_recipe)
  }

  before :all do
    expect(File).not_to be_exists('/var/root/.ssh')
    expect(File).not_to be_exists('/var/root/.ssh/config')
    expect(File).not_to be_exists('/var/root/.ssh/known_hosts')
  end

  it 'creates directory /var/root/.ssh' do
    expect(chef_run).to create_directory(root_ssh).with(
      owner: 'root',
      group: 'wheel',
      mode: '0700'
    )
  end

  it 'creates known_hosts file if missing' do
    expect(chef_run).to create_file_if_missing(root_ssh_known_hosts).with(
      owner: 'root',
      group: 'wheel',
      mode: '0644'
    )
  end

  it 'adds github rsa keys to known_hosts' do
    expect(chef_run).to run_execute('add github to known_hosts').with(user: 'root')
  end

  it 'creates a template for /var/root/.ssh/config' do
    expect(chef_run).to create_template(root_ssh_config).with(
      user: 'root',
      group: 'wheel',
      mode: '0600'
    )
  end

  it 'creates minimal root user github.com ssh config' do
    expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+IdentityFile\s+\/Users\/brubble\/.ssh\/identity.brubble$/)
    expect(chef_run).to render_file(root_ssh_config).with_content(/^Host github\.com$/)
    expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+User\s+git$/)
    expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+Hostname\s+github\.com$/)
    expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+PreferredAuthentications\s+publickey$/)
    expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+StrictHostKeyChecking\s+no$/)
    expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+UserKnownHostsFile\s+\/dev\/null$/)
  end
end
