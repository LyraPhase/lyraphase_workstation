# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: hammerspoon_shiftit
# Site:: https://github.com/miromannino/miro-windows-manager
# Reference:: https://github.com/fikovnik/ShiftIt/issues/299
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2013-2022 James Cuzella
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
#

include_recipe 'lyraphase_workstation::hammerspoon'

hammerspoon_git_checkout_dir = "#{node['lyraphase_workstation']['home']}/.hammerspoon/git-checkout-Spoons"
hammerspoon_spoons_dir = "#{node['lyraphase_workstation']['home']}/.hammerspoon/Spoons"

git "#{hammerspoon_git_checkout_dir}/miro-windows-manager" do
  repository node['lyraphase_workstation']['hammerspoon_shiftit']['spoon_git_url']
  revision node['lyraphase_workstation']['hammerspoon_shiftit']['spoon_git_hash'] || 'HEAD'
  action :sync
  user node['lyraphase_workstation']['user']
  enable_submodules true
end

['MiroWindowsManager.spoon'].each do |spoon|
  link "#{hammerspoon_spoons_dir}/#{spoon}" do
    to "#{hammerspoon_git_checkout_dir}/miro-windows-manager/#{spoon}"
    owner node['lyraphase_workstation']['user']
    not_if { File.symlink?("#{hammerspoon_spoons_dir}/#{spoon}") }
  end
end
