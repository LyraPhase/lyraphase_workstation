require 'spec_helper'

describe 'lyraphase_workstation::default' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new do |node|
      Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire)
      node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.set['sprout']['user'] = 'brubble'
      node.set['sprout']['home'] = '/Users/brubble'
    end.converge(described_recipe)
  }

  before do
    stub_const('ENV', ENV.to_hash.merge('SUDO_USER' => 'brubble'))
  end

  it 'should do nothing' do
    expect(chef_run.resource_collection).to be_empty
  end
end
