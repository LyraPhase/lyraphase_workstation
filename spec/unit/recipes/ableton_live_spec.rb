require 'spec_helper'

describe 'lyraphase_workstation::ableton_live' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/ableton_live_suite_9.1.9_64.dmg',
        'checksum' => '7a4da8531180afa8c7930a961289da1a0df567a8495e7ec205c7780f85dd0fda',
        'volumes_dir' => 'Ableton Live 9 Suite Installer',
        'dmg_name' => 'ableton_live_suite_9.1.9_64',
        'app' => 'Ableton Live 9 Suite',
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

        node.normal['lyraphase_workstation']['ableton_live']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Ableton Live DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Ableton Live')
    end
  end


  context "when using default attributes" do
      let(:cf_bundle_id) { 'com.caiaq.driver.NIUSBTraktorAudio2Driver' }
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.normal['lyraphase_workstation']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs Ableton Live DMG" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package('Ableton Live')
      end

  end
end
