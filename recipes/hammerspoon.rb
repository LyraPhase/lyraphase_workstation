#
# Cookbook Name:: lyraphase_workstation
# Recipe:: hammerspoon
# Site:: http://www.hammerspoon.org
#
# Copyright (C) © 🄯  2013-2020 James Cuzella
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

if ! node.attribute?(node['homebrew']['formulas'])
  node.default['homebrew']['formulas'] = []
end

unless has_formula_named?(node['homebrew']['formulas'], 'hammerspoon')
  node.default['homebrew']['formulas'].push('hammerspoon')
end

homebrew_cask 'hammerspoon'

hammerspoon_init_lua = "#{node['lyraphase_workstation']['home']}/.hammerspoon/init.lua"
hammerspoon_git_checkout_dir = "#{node['lyraphase_workstation']['home']}/.hammerspoon/git-checkout-Spoons"
hammerspoon_spoons_dir = "#{node['lyraphase_workstation']['home']}/.hammerspoon/Spoons"

[hammerspoon_git_checkout_dir, hammerspoon_spoons_dir].each do |hammerspoon_dir|
  directory hammerspoon_dir do
    owner node['lyraphase_workstation']['user']
    group 'staff'
    mode '0755'
    recursive true
    action :create
  end
end

cookbook_file hammerspoon_init_lua do
  source "hammerspoon/init.lua"
  user node['lyraphase_workstation']['user']
  group 'staff'
  mode "0644"
end
