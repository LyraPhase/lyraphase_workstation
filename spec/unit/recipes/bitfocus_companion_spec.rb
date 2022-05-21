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
require 'chef/exceptions'

describe 'lyraphase_workstation::bitfocus_companion' do
  let(:dmg_properties_x86_64) do
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
  let(:dmg_properties_arm64) do
    {
      'source' => 'http://www.lyraphase.com/doc/installers/mac/bitfocus-companion-2.2.0-ccea40c7-mac-arm64.dmg',
      'checksum' => 'ca7d293f0ada8574465f02af08110655a2b61ca3351cd6d4a0e83a34e6ea053d',
      'volumes_dir' => 'Companion 2.2.0',
      'dmg_name' => 'bitfocus-companion-2.2.0-ccea40c7-mac-arm64',
      'app' => 'Companion',
      'pkg_id' => 'companion.bitfocus.no',
      'type' => 'app',
    }
  end

  context 'when given DMG attributes, on MacOS 10.15 with x86_64 architecture' do
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

        node.automatic['kernel']['machine'] = 'x86_64'
        node.normal['lyraphase_workstation']['bitfocus_companion']['dmg'] = dmg_properties_x86_64
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs x86_64 Bitfocus Companion DMG' do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties_x86_64['volumes_dir']).with(
          source: dmg_properties_x86_64['source'],
          dmg_name: dmg_properties_x86_64['dmg_name']
        )
    end
  end

  context 'when run with default recipe attributes on x86_64 architecture' do
    let(:chef_run) do
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.automatic['kernel']['machine'] = 'x86_64'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs DMG' do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties_x86_64['volumes_dir'])
    end
  end

  context 'when on MacOS 12 with Apple Silicon arm64 architecture' do
    platform 'mac_os_x', '12'

    let(:chef_run) do
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.automatic['kernel']['machine'] = 'arm64'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs arm64 Bitfocus Companion DMG' do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties_arm64['volumes_dir']).with(
          source: dmg_properties_arm64['source'],
          dmg_name: dmg_properties_arm64['dmg_name']
        )
    end
  end

  context 'when on unknown unsupported architecture: RiscV' do
    let(:chef_run) do
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.automatic['kernel']['machine'] = 'riscv'
      end.converge(described_recipe)
    end

    it 'raises Chef::Exceptions::UnsupportedPlatform error' do
      expect { chef_run }.to raise_error(Chef::Exceptions::UnsupportedPlatform)
    end
  end

end
