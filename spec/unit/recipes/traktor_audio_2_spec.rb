require 'spec_helper'

describe 'lyraphase_workstation::traktor_audio_2' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://lyraphase.com/doc/installers/mac/Traktor_Audio_2_270_Mac_p.dmg',
        'checksum' => 'e73d7ce1d023297e8081ae72c8cb23539efc18ed7c549df7ef5e19590c72d54e',
        'volumes_dir' => 'Traktor Audio 2',
        'dmg_name' => 'Traktor_Audio_2_270_Mac_p',
        'app' => 'Traktor Audio 2 2.7.0 Installer Mac',
        'type' => 'pkg',
        'package_id' => 'com.caiaq.NIUSBTraktorAudio2Driver_10.9'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['sprout']['user'] = 'brubble'

        node.set['lyraphase_workstation']['traktor_audio_2']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Traktor Audio 2 DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['app'])
    end
  end


  [
    { platform: 'mac_os_x', version: '10.6.8',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Snow Leopard',  disable_app_nap: false },
    { platform: 'mac_os_x', version: '10.7.4',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Lion',          disable_app_nap: false },
    { platform: 'mac_os_x', version: '10.8.2',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Mountain Lion', disable_app_nap: false },
    { platform: 'mac_os_x', version: '10.9.2',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Mavericks',     disable_app_nap: true },
    { platform: 'mac_os_x', version: '10.10',   dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Yosemite',      disable_app_nap: true },
    { platform: 'mac_os_x', version: '10.11.1', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'El Capitan',    disable_app_nap: true }
  ].each do |os|
    context "on #{os[:platform].split('_').map(&:capitalize).join(' ')} #{os[:version]} (#{os[:code_name]})" do
      let(:cf_bundle_id) { 'com.caiaq.driver.NIUSBTraktorAudio2Driver' }
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new(os) do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.set['sprout']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs DMG #{os[:dmg_app]}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package(os[:dmg_app])
      end

      if os[:disable_app_nap]
        it "disables app nap" do
          expect(chef_run).to write_osx_defaults(cf_bundle_id, 'NSAppSleepDisabled').with_boolean(true)
        end
      end
    end
  end
end
