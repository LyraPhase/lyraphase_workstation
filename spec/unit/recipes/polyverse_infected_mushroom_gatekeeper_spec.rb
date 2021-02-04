#
# Cookbook:: lyraphase_workstation
# Spec:: polyverse_infected_mushroom_gatekeeper
#
# Copyright:: (C) © 🄯  2013-2021 James Cuzella
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'spec_helper'

describe 'lyraphase_workstation::polyverse_infected_mushroom_gatekeeper' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/InfectedMushroom-GatekeeperV1.2.dmg',
        'checksum' => 'a13445159e4faea33daedc28cdc310b8f7e00e7b53848bc8ab333b50631197f3',
        'volumes_dir' => 'Gatekeeper Setup',
        'dmg_name' => 'InfectedMushroom-GatekeeperV1.2',
        'app' => 'Gatekeeper Setup',
        'package_id' => 'com.polyversemusic.pkg.gatekeeperVST64',
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

        node.normal['lyraphase_workstation']['polyverse_infected_mushroom_gatekeeper']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Polyverse Gatekeeper DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - Gatekeeper VST')
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

        node.normal['lyraphase_workstation']['polyverse_infected_mushroom_gatekeeper']['license'] = license_data
      end.converge(described_recipe)
    }

    it "installs Polyverse Gatekeeper DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - Gatekeeper VST')
    end

    it "creates Polyverse dir under User's Library dir" do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory( File.join(user_library_dir, 'Polyverse') ).with( owner: 'brubble' )
    end

    it "installs License Key" do
      expect(chef_run).to render_file(File.join(user_library_dir, 'Polyverse', 'Gatekeeper', 'key.pvkey')).with_content(license_data['email'] + '|' + license_data['key'])
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

      it "installs Polyverse - Infected Mushroom - Gatekeeper VST DMG" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package('Polyverse - Infected Mushroom - Gatekeeper VST')
      end

  end
end
