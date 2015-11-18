#
# Cookbook Name:: lyraphase_workstation
# Recipe:: traktor_audio_2
# Site:: http://www.native-instruments.com/en/products/traktor/dj-audio-interfaces/traktor-audio-2/
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
dmg_properties = node['lyraphase_workstation']['traktor_audio_2']['dmg']

dmg_package dmg_properties['app'] do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  dmg_name    dmg_properties['dmg_name']
  app         dmg_properties['app']
  type        dmg_properties['type']
  owner       node['current_user']
  package_id  dmg_properties['package_id']
  action :install
end
