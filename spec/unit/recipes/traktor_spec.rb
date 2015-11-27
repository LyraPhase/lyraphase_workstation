require 'spec_helper'

describe 'lyraphase_workstation::traktor' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/TraktorPro26.dmg',
        'checksum' => 'c840fa5fa58cad2a7eec44049c3908b7059575d3103a7e5fe6de14829b489066',
        'volumes_dir' => 'Traktor Pro 2.6',
        'dmg_name' => 'TraktorPro26',
        'app' => 'Traktor 2 2.6.0 Mac',
        'type' => 'mpkg'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['lyraphase_workstation']['user'] = 'brubble'

        node.set['lyraphase_workstation']['traktor']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Traktor Pro 2.6 DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['volumes_dir'])
    end
  end


  [
    { platform: 'mac_os_x', version: '10.6.8',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Snow Leopard',  disable_app_nap: false },
    { platform: 'mac_os_x', version: '10.7.4',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Lion',          disable_app_nap: false },
    { platform: 'mac_os_x', version: '10.8.2',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Mountain Lion', disable_app_nap: false },
    { platform: 'mac_os_x', version: '10.9.2',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Mavericks',     disable_app_nap: true },
    { platform: 'mac_os_x', version: '10.10',   dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Yosemite',      disable_app_nap: true },
    { platform: 'mac_os_x', version: '10.11.1', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'El Capitan',    disable_app_nap: true }
  ].each do |os|
    context "on #{os[:platform].split('_').map(&:capitalize).join(' ')} #{os[:version]} (#{os[:code_name]})" do
      let(:cf_bundle_id) { 'com.native-instruments.Traktor2.Application' }
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new(os) do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.set['lyraphase_workstation']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs DMG #{os[:dmg_volumes_dir]}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package(os[:dmg_volumes_dir])
      end

      if os[:disable_app_nap]
        it "disables app nap" do
          expect(chef_run).to write_osx_defaults(cf_bundle_id, 'NSAppSleepDisabled').with_boolean(true)
        end
      end
    end
  end
end
