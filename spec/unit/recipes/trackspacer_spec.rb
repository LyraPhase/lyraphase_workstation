require 'spec_helper'

describe 'lyraphase_workstation::trackspacer' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/Trackspacer_V205.dmg',
        'checksum' => '58d04c49e396eda56ed1d07bf7716e4e3355bec5dabd7931208a3be4fedd2840',
        'volumes_dir' => 'Trackspacer 2.0.5 Full',
        'dmg_name' => 'Trackspacer_V205',
        'app' => 'Trackspacer',
        'type' => 'mpkg'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['trackspacer']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Ableton Live DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['app'])
    end
  end

  # context 'when given License Key attributes' do
  #   let(:license_data) {
  #     {
  #       'serial' => 'YmFybmV5LnJ1YmJsZUBnbWFpbC5jb20AbGljZW5zZQ=='
  #     }
  #   }
  #   let(:user_library_dir) {
  #     '/Users/brubble/Library'
  #   }
  #   let(:chef_run) {
  #     klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
  #     klass.new do |node|
  #       # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
  #       create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
  #       node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
  #       node.normal['lyraphase_workstation']['user'] = 'brubble'
  #       node.normal['lyraphase_workstation']['home'] = '/Users/brubble'
  #       node.normal['current_user'] = 'brubble'

  #       node.normal['lyraphase_workstation']['trackspacer']['license'] = license_data
  #     end.converge(described_recipe)
  #   }

  #   it "installs Ableton Live DMG" do
  #     chef_run.converge(described_recipe)
  #     expect(chef_run).to install_dmg_package(dmg_properties['app'])
  #   end

  #   it "creates Polyverse dir under User's Library dir" do
  #     chef_run.converge(described_recipe)
  #     expect(chef_run).to create_directory( File.join(user_library_dir, 'Polyverse') ).with( owner: 'brubble' )
  #   end

  #   it "installs License Key" do
  #     expect(chef_run).to render_file(File.join(user_library_dir, 'Polyverse', 'iwish', 'key.pvs')).with_content(license_data['email'] + '|' + license_data['key'])
  #   end
  # end

  context "when using default attributes" do
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.normal['lyraphase_workstation']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs Wavesfactory - Trackspacer DMG" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package('Trackspacer')
      end

  end
end
