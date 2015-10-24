#
# Cookbook Name:: lyraphase_workstation
# Recipe:: vimrc
#
# Copyright (C) 2013,2014 James Cuzella
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
git node["vim_home"] do
  repository node["vim_config_git"]
  branch "master"
  revision node["vim_hash"] || "HEAD"
  action :sync
  user node['lyraphase_workstation']['user']
  enable_submodules true
end

%w{vimrc gvimrc}.each do |vimrc|
  link "#{node['lyraphase_workstation']['home']}/.#{vimrc}" do
    to "#{node["vim_home"]}/#{vimrc}"
    owner node['lyraphase_workstation']['user']
    not_if { File.symlink?("#{node["vim_home"]}/#{vimrc}") }
  end
end

file "#{node['lyraphase_workstation']['home']}/.vimrc.local" do
  action :touch
  owner node['lyraphase_workstation']['user']
  not_if { File.exists?("#{WS_HOME}/.vimrc.local") }
end
