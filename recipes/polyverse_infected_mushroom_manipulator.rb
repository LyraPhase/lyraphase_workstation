#
# Cookbook Name:: lyraphase_workstation
# Recipe:: polyverse_infected_mushroom_manipulator
# Site:: http://polyversemusic.com/
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

dmg_properties = node['lyraphase_workstation']['polyverse_infected_mushroom_manipulator']['dmg']

dmg_package "Polyverse - Infected Mushroom - Manipulator VST" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  dmg_name    dmg_properties['dmg_name']
  app         dmg_properties['app']
  type        dmg_properties['type']
  owner       node['lyraphase_workstation']['user']
  package_id  dmg_properties['package_id']
  # accept_eula true
  action :install
end

user_library_dir = "#{node['lyraphase_workstation']['home']}/Library"

recursive_directories([user_library_dir, "Polyverse", "Manipulator"]) do
  owner node['lyraphase_workstation']['user']
end

license_data = data_bag_item('lyraphase_workstation', 'polyverse_infected_mushroom_manipulator')['license'] rescue nil

if license_data.nil? && ! node['lyraphase_workstation']['polyverse_infected_mushroom_manipulator']['license'].nil? && ! node['lyraphase_workstation']['polyverse_infected_mushroom_manipulator']['license']['email'].nil? && ! node['lyraphase_workstation']['polyverse_infected_mushroom_manipulator']['license']['key'].nil?
  license_data = node['lyraphase_workstation']['polyverse_infected_mushroom_manipulator']['license']
end

template File.join(user_library_dir, 'Polyverse', 'Manipulator', 'key.pvkey') do
  source "License.Polyverse.manipulator.erb"
  owner node['lyraphase_workstation']['user']
  variables :license => license_data
  not_if { license_data.nil? }
end
