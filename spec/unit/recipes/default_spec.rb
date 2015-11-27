require 'spec_helper'

describe 'lyraphase_workstation::default' do
  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.set['lyraphase_workstation']['user'] = 'brubble'
      node.set['lyraphase_workstation']['home'] = '/Users/brubble'
    end.converge(described_recipe)
  }

  it 'should do nothing' do
    expect(chef_run.resource_collection).to be_empty
  end
end
