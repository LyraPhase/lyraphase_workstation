# -*- coding: utf-8 -*-
#
# Copyright (C) 2015-2019 James Cuzella
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

describe 'lyraphase_workstation::hammerspoon_shiftit' do

  let(:hammerspoon_init_lua) { '/Users/brubble/.hammerspoon/init.lua' }
  let(:hammerspoon_git_checkout_dir) { '/Users/brubble/.hammerspoon/git-checkout-Spoons' }
  let(:hammerspoon_spoons_dir) { '/Users/brubble/.hammerspoon/Spoons' }
  let(:hammerspoon_miro_windows_manager_git_url) { 'https://github.com/miromannino/miro-windows-manager.git' }
  let(:hammerspoon_miro_windows_manager_git_sha) { '9f3ee0785b5e8963c2765f1e29a310937b20a09c' }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.default['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.default['lyraphase_workstation']['user'] = 'brubble'
      node.default['lyraphase_workstation']['home'] = '/Users/brubble'
      node.automatic['hostname'] = 'bedrock'

      node.default['lyraphase_workstation']['hammerspoon_shiftit']['spoon_git_url'] = 'https://github.com/miromannino/miro-windows-manager.git'
      node.default['lyraphase_workstation']['hammerspoon_shiftit']['spoon_git_hash'] = '9f3ee0785b5e8963c2765f1e29a310937b20a09c'
    end.converge(described_recipe)
  }

  it 'installs Hammerspoon recipe' do
    expect(chef_run).to include_recipe('lyraphase_workstation::hammerspoon')
  end

  it 'syncs hammerspoon miro-windows-manager spoon git repo' do
    expect(chef_run).to sync_git("#{hammerspoon_git_checkout_dir}/miro-windows-manager").with(
      repository: hammerspoon_miro_windows_manager_git_url,
      revision: hammerspoon_miro_windows_manager_git_sha,
      user: 'brubble',
      enable_submodules: true
    )
  end

  it 'installs miro-windows-manager via symlink' do
    expect(chef_run).to create_link("#{hammerspoon_spoons_dir}/MiroWindowsManager.spoon").with(
      owner: 'brubble',
      to: "#{hammerspoon_git_checkout_dir}/miro-windows-manager/MiroWindowsManager.spoon"
    )
  end
end
