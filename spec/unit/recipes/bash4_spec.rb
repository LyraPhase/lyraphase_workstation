# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2016-2020 James Cuzella
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

describe 'lyraphase_workstation::bash4' do

  let(:etc_shells_path) { "/etc/shells" }
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
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      node.normal['lyraphase_workstation']['bash']['etc_shells_path'] = etc_shells_path
      node.normal['lyraphase_workstation']['bash']['etc_shells'] = etc_shells
      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -q '\/usr\/local\/bin\/bash'").and_return(false)
    end.converge(described_recipe)
  }

  it 'installs gnugpg21 via homebrew' do
    [
      'bash',
      'bash-completion@2'
    ].each do |pkg|
      expect(chef_run.node['homebrew']['formulas']).to include(pkg)
      expect(chef_run).to install_package(pkg)
    end
  end

  it 'installs homebrew bash into /etc/shells' do
    expect(chef_run).to create_template(etc_shells_path).with(
      user:   'brubble',
      mode: '0644'
    )

    etc_shells.each do |expected_shell|
      expect(chef_run).to render_file(etc_shells_path).with_content(Regexp.new("^#{expected_shell}$"))
    end
  end


  context 'when set_login_shell is true' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['bash']['etc_shells_path'] = etc_shells_path
        node.normal['lyraphase_workstation']['bash']['etc_shells'] = etc_shells
        stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -q '\/usr\/local\/bin\/bash'").and_return(false)
        node.normal['lyraphase_workstation']['bash']['set_login_shell'] = true
      end.converge(described_recipe)
    }
    before(:each) do
      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -q '\/usr\/local\/bin\/bash'").and_return(false)
    end

    it 'changes login shell to homebrew bash4' do
      expect(chef_run).to run_execute 'change login shell to homebrew bash4'
    end
  end

  context 'when set_login_shell is false' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['bash']['etc_shells_path'] = etc_shells_path
        node.normal['lyraphase_workstation']['bash']['etc_shells'] = etc_shells
        stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -q '\/usr\/local\/bin\/bash'").and_return(false)
        node.normal['lyraphase_workstation']['bash']['set_login_shell'] = false
      end.converge(described_recipe)
    }
    before(:each) do
      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -q '\/usr\/local\/bin\/bash'").and_return(false)
    end

    it 'changes login shell to homebrew bash4' do
      expect(chef_run).to_not run_execute 'change login shell to homebrew bash4'
    end
  end
end

