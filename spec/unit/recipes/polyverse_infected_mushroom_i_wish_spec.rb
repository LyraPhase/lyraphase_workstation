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
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['sprout']['user'] = 'brubble'

        node.set['lyraphase_workstation']['polyverse_infected_mushroom_i_wish']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Ableton Live DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - I Wish VST')
    end
  end


  context "when using default attributes" do
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.set['sprout']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs Polyverse - Infected Mushroom - I Wish DMG" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - I Wish VST')
      end

  end
end
