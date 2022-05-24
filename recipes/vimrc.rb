# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: vimrc
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
git node['vim_home'] do
  repository node['vim_config_git']
  branch 'master'
  revision node['vim_hash'] || 'HEAD'
  action :sync
  user node['lyraphase_workstation']['user']
  enable_submodules true
end

['vimrc', 'gvimrc'].each do |vimrc|
  link "#{node['lyraphase_workstation']['home']}/.#{vimrc}" do
    to "#{node['vim_home']}/#{vimrc}"
    owner node['lyraphase_workstation']['user']
    not_if { File.symlink?("#{node['vim_home']}/#{vimrc}") }
  end
end

file "#{node['lyraphase_workstation']['home']}/.vimrc.local" do
  action :touch
  owner node['lyraphase_workstation']['user']
  not_if { ::File.exist?("#{WS_HOME}/.vimrc.local") }
end
