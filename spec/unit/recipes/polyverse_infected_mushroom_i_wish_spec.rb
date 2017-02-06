require 'spec_helper'

describe 'lyraphase_workstation::polyverse_infected_mushroom_i_wish' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/Infected Mushroom - I Wish v0.910.dmg',
        'checksum' => 'd63dbfde7554b5c3129992bb70bd88d28b4a6b27f0ca763fb9a7245617138390',
        'volumes_dir' => 'Infected Mushroom - I wish 0.9',
        'dmg_name' => 'Infected Mushroom - I Wish v0.910',
        'app' => 'I Wish Setup',
        'type' => 'pkg'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['polyverse_infected_mushroom_i_wish']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Ableton Live DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - I Wish VST')
    end
  end

  context 'when given License Key attributes' do
    let(:license_data) {
      {
        'email' => 'barney.rubble@gmail.com',
        'key' => 'YmFybmV5LnJ1YmJsZUBnbWFpbC5jb20AbGljZW5zZQ=='
      }
    }
    let(:user_library_dir) {
      '/Users/brubble/Library'
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'
        node.normal['current_user'] = 'brubble'

        node.normal['lyraphase_workstation']['polyverse_infected_mushroom_i_wish']['license'] = license_data
      end.converge(described_recipe)
    }

    it "installs Ableton Live DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - I Wish VST')
    end

    it "creates Polyverse dir under User's Library dir" do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory( File.join(user_library_dir, 'Polyverse') ).with( owner: 'brubble' )
    end

    it "installs License Key" do
      expect(chef_run).to render_file(File.join(user_library_dir, 'Polyverse', 'iwish', 'key.pvs')).with_content(license_data['email'] + '|' + license_data['key'])
    end
  end

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

      it "installs Polyverse - Infected Mushroom - I Wish DMG" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - I Wish VST')
      end

  end
end
