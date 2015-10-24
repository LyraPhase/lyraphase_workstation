#
# Cookbook Name:: lyraphase_workstation
# Recipe:: omnifocus
# Site:: https://www.omnigroup.com/omnifocus
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
dmg_properties = node['lyraphase_workstation']['omnifocus']['dmg']

dmg_package "OmniFocus" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  owner       node['current_user']
  type 'app'
  accept_eula true
  #package_id  'com.native-instruments.Traktor2.*'
end

# TODO: Install license, remove sprout attribute dependency
# app_supportdir = "#{node['sprout']['home']}/Library/Application Support"

# recursive_directories([app_supportdir, "Omni Group", "Software Licenses/"]) do
#   owner node['current_user']
# end

# template File.join(app_supportdir, 'DaisyDisk', 'License.DaisyDisk') do
#   source "License.DaisyDisk.erb"
#   owner node['current_user']
#   variables :license => node['lyraphase_workstation']['omnifocus']['license']
#   not_if { node['lyraphase_workstation']['omnifocus']['license']['owner'].nil? || node['lyraphase_workstation']['omnifocus']['license']['key'].nil? }
# end
