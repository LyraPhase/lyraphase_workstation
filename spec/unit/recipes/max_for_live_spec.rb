require 'spec_helper'

describe 'lyraphase_workstation::max_for_live' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/Max8110_210222.dmg',
        'checksum' => 'b44f218fa00d279b3e55accfa583835e7d30e7228618e07bdec51110fc3f3b8a',
        'volumes_dir' => 'Max8110',
        'dmg_name' => 'Max8110_210222',
        'app' => 'Max',
        'type' => 'app'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['max_for_live']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Max 4 Live DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Max for Live')
    end
  end


  context "when using default attributes" do
      let(:cf_bundle_id) { 'com.cycling74.Max61.pkg' }
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.normal['lyraphase_workstation']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs Max 4 Live DMG" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package('Max for Live')
      end

  end
end
