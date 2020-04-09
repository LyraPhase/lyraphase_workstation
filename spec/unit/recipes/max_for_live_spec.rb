require 'spec_helper'

describe 'lyraphase_workstation::max_for_live' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/Max813_200310.dmg',
        'checksum' => 'e452b62f2932582001a2f3b49d731a02177857d4d775b4f55fc6313a03bb575d',
        'volumes_dir' => 'Max813',
        'dmg_name' => 'Max813_200310',
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
