require 'spec_helper'

describe 'lyraphase_workstation::kontakt' do

  let(:dmg_properties) {
    {
      'source' => 'http://www.lyraphase.com/doc/installers/mac/Kontakt_5_551451U_Mac.dmg',
      'checksum' => '0bb0386099eb951cff90ec3d5c7068c5f32862ea593893ee761ece25c1877fb3',
      'volumes_dir' => 'Kontakt 5',
      'dmg_name' => 'Kontakt_5_551451U_Mac',
      'app' => 'Kontakt 5 5.5.1 Installer Mac',
      'pkg_id' => 'com.native-instruments.Kontakt5.VST',
      'type' => 'pkg'
    }
  }

  context 'when given DMG attributes' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['kontakt']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Kontakt DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['volumes_dir'])
    end
  end

  context 'when run with default recipe attributes' do
    let(:chef_run) do
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
      end.converge(described_recipe)
    end

    it "installs DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['volumes_dir'])
    end
  end
end
