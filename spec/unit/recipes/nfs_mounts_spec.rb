require 'spec_helper'

describe 'lyraphase_workstation::nfs_mounts' do
  let(:chef_run) do
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'

      node.normal['lyraphase_workstation']['nfs_mounts'] = [
        '#/../Volumes/nfsv4root    -fstype=nfs,noowners,nolockd,noresvport,hard,bg,intr,rw,tcp,nfc nfs://192.168.1.100:/export',
        '/../Volumes/foo    -fstype=nfs,nolockd,resvport,hard,bg,intr,rw,tcp,nfc nfs://192.168.1.100:/export/foo',
      ]
    end.converge(described_recipe)
  end

  [ '/etc/auto_nfs', '/etc/auto_master' ].each do |path|
    it "creates a template for #{path}" do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_template(path).with(
        user: 'root',
        group: 'wheel',
        mode: '0644'
      )
    end

    it "reloads automount when #{path} changes" do
      chef_run.converge(described_recipe)
      resource = chef_run.template(path)
      expect(resource).to notify('execute[reload automount]').to(:run).delayed
    end
  end

  it 'sets up an execute task for "reload automount" that does nothing until notified' do
    execute = chef_run.execute('reload automount')
    expect(execute).to do_nothing
  end
end
