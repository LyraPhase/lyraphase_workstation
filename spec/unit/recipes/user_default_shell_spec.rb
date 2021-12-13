# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2016-2021 James Cuzella
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

describe 'lyraphase_workstation::user_default_shell' do

  let(:default_shell) { "/bin/bash" }
  let(:etc_shells) {
    [
      '/usr/local/bin/bash',
      '/bin/bash',
      '/bin/csh',
      '/bin/ksh',
      '/bin/sh',
      '/bin/tcsh',
      '/bin/zsh'
    ]
  }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.11') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      # MacOS Catalina and later set default shell to: /bin/zsh
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/zsh', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      node.normal['lyraphase_workstation']['user_default_shell']['shell'] = default_shell
      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -Eq '\\/bin\\/bash'").and_return(false)
    end.converge(described_recipe)
  }

  context 'when set_login_shell is true' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        # MacOS Catalina and later set default shell to: /bin/zsh
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/zsh', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['user_default_shell']['shell'] = default_shell
        stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -Eq '\\/bin\\/bash'").and_return(false)
        node.normal['lyraphase_workstation']['user_default_shell']['set_login_shell'] = true
      end.converge(described_recipe)
    }
    before(:each) do
      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -Eq '\\/bin\\/bash'").and_return(false)
    end

    it 'changes login shell' do
      expect(chef_run).to run_execute 'change login shell'
    end

    it 'changes login shell to bash' do
      expect(chef_run).to run_execute('change login shell').with(command: "chsh -s -u brubble #{default_shell}")
    end
  end

  context 'when set_login_shell is false' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        # MacOS Catalina and later set default shell to: /bin/zsh
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/zsh', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['user_default_shell']['shell'] = default_shell

        stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -Eq '\\/bin\\/bash'").and_return(false)
        node.normal['lyraphase_workstation']['user_default_shell']['set_login_shell'] = false
      end.converge(described_recipe)
    }
    before(:each) do
      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -Eq '\\/bin\\/bash'").and_return(false)
    end

    it 'does not change login shell' do
      expect(chef_run).to_not run_execute 'change login shell'
    end
  end
end

