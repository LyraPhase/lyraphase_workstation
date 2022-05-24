#
# Cookbook:: lyraphase_workstation
# Spec:: audinate_dante_controller
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

describe 'lyraphase_workstation::audinate_dante_controller' do
  let(:dmg_properties) do
    {
      'source' => 'http://www.lyraphase.com/doc/installers/mac/DanteController-4.2.7.1_macos.dmg',
      'checksum' => 'e601346160478447ccd572810ae01343e4beb76644554f4ed62d707c733a3547',
      'volumes_dir' => 'Dante Controller',
      'dmg_name' => 'DanteController-4.2.7.1_macos',
      'app' => '',
      'pkg_id' => 'com.audinate.DanteController.pkg',
      'type' => 'pkg',
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

        node.normal['lyraphase_workstation']['polyverse_infected_mushroom_gatekeeper']['dmg'] = dmg_properties
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
