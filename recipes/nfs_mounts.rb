#
# Cookbook Name:: lyraphase_workstation
# Recipe:: nfs_mounts
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

template "/etc/auto_nfs" do
  source 'auto_nfs.erb'
  owner 'root'
  group 'wheel'
  mode '0644'
  action :create

  variables({
     :nfs_mounts => node[:lyraphase_workstation][:nfs_mounts]
  })
  notifies :run, 'execute[reload automount]', :delayed
end

# Added a single line to the end of /etc/audo_master to load /etc/auto_nfs
# Manage the whole file rather than "line in file" for idempotence
template "/etc/auto_master" do
  source 'auto_master.erb'
  owner 'root'
  group 'wheel'
  mode '0644'
  action :create
  notifies :run, 'execute[reload automount]', :delayed
end

execute 'reload automount' do
  command 'automount -cv'
  user 'root'
  action :nothing
end