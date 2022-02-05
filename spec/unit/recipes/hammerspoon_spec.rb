# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Spec:: hammerspoon
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2015-2022 James Cuzella
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

describe 'lyraphase_workstation::hammerspoon' do
  let(:hammerspoon_init_lua) { '/Users/brubble/.hammerspoon/init.lua' }
  let(:hammerspoon_git_checkout_dir) { '/Users/brubble/.hammerspoon/git-checkout-Spoons' }
  let(:hammerspoon_spoons_dir) { '/Users/brubble/.hammerspoon/Spoons' }

  let(:chef_run) do
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.default['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.default['lyraphase_workstation']['user'] = 'brubble'
      node.default['lyraphase_workstation']['home'] = '/Users/brubble'
      node.automatic['hostname'] = 'bedrock'
    end.converge(described_recipe)
  end

  it 'installs Hammerspoon Homebrew Formula' do
    expect(chef_run).to install_homebrew_cask('hammerspoon')
  end

  it 'creates .hammerspoon directories' do
    [hammerspoon_git_checkout_dir, hammerspoon_spoons_dir].each do |hammerspoon_dir|
      expect(chef_run).to create_directory(hammerspoon_dir).with(
        user: 'brubble',
        group: 'staff',
        mode: '0755'
      )
    end
  end

  it 'installs hammerspoon init.lua' do
    expect(chef_run).to create_cookbook_file(hammerspoon_init_lua).with(
      owner: 'brubble',
      group: 'staff',
      mode: '0644'
    )
  end
end
