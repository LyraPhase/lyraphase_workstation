#
# Cookbook:: lyraphase_workstation
# Spec:: bitfocus_companion
#
# Copyright:: (C) © 🄯  2022 James Cuzella
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

describe 'lyraphase_workstation::bitfocus_companion' do
  let(:dmg_properties) do
    {
      'source' => 'http://www.lyraphase.com/doc/installers/mac/bitfocus-companion-2.2.0-ccea40c7-mac-x64.dmg',
      'checksum' => 'e1b7015eb4e14ad1cc7b9068fff19f53a137512fc6570e849369d15921762020',
      'volumes_dir' => 'Companion 2.2.0',
      'dmg_name' => 'bitfocus-companion-2.2.0-ccea40c7-mac-x64',
      'app' => 'Companion',
      'pkg_id' => 'companion.bitfocus.no',
      'type' => 'app',
    }
  end

  context 'when given DMG attributes, on MacOS 10.15' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'mac_os_x', '10.15'

    let(:chef_run) do
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['bitfocus_companion']['dmg'] = dmg_properties
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs Dante Controller DMG' do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['volumes_dir'])
    end
  end

  context 'when run with default recipe attributes' do
    let(:chef_run) do
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs DMG' do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['volumes_dir'])
    end
  end
end
