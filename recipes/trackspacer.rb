#
# Cookbook Name:: lyraphase_workstation
# Recipe:: trackspacer
# Site:: https://www.wavesfactory.com/product/trackspacer/
#
# Copyright (C) 2017 James Cuzella
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
dmg_properties = node['lyraphase_workstation']['trackspacer']['dmg']

dmg_package "Trackspacer" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  dmg_name    dmg_properties['dmg_name']
  app         dmg_properties['app']
  type        dmg_properties['type']
  owner       node['lyraphase_workstation']['user']
  action :install
end

license_key_data = Chef::EncryptedDataBagItem.load('lyraphase_workstation', 'trackspacer')['license'] rescue nil

if license_key_data.nil? && ! node['lyraphase_workstation']['trackspacer']['license'].nil? && ! node['lyraphase_workstation']['trackspacer']['license']['serial']
  license_key_data = node['lyraphase_workstation']['trackspacer']['license']
end

