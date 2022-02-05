#
# Cookbook Name:: lyraphase_workstation
# Recipe:: daisydisk
# Site:: http://www.daisydiskapp.com/
#
# Copyright (C) © 🄯  2015-2020 James Cuzella
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

dmg_properties = node['lyraphase_workstation']['daisydisk']['dmg']
zip_properties = node['lyraphase_workstation']['daisydisk']['zip']

if ! dmg_properties.nil? && zip_properties.nil?
  dmg_package "DaisyDisk" do
    source      dmg_properties['source']
    checksum    dmg_properties['checksum']
    volumes_dir dmg_properties['volumes_dir']
    owner       node['lyraphase_workstation']['user']
  end

elsif ! zip_properties.nil? && dmg_properties.nil?
  app_path='/Applications/DaisyDisk.app'

  unless File.exists?(app_path)
    remote_file "#{Chef::Config[:file_cache_path]}/DaisyDisk.zip" do
      source   zip_properties['source']
      checksum zip_properties['checksum']
      mode     '0644'
    end

    execute 'unzip DaisyDisk' do
      command "unzip #{Chef::Config[:file_cache_path]}/DaisyDisk.zip DaisyDisk.app/* -d /Applications/"
      user    node['lyraphase_workstation']['user']
      group   'admin'
    end
  end
else
  Chef::Log::warn("node['lyraphase_workstation']['daisydisk']['dmg'] and node['lyraphase_workstation']['daisydisk']['zip'] were both specified!  Not sure which you intended to use.  Please pick one!")
end

app_supportdir = "#{node['lyraphase_workstation']['home']}/Library/Application Support"

recursive_directories([app_supportdir, "DaisyDisk"]) do
  owner node['lyraphase_workstation']['user']
end

license_data = data_bag_item('lyraphase_workstation', 'daisydisk')['license'] rescue nil

if license_data.nil? && ! node['lyraphase_workstation']['daisydisk']['license'].nil? && ! node['lyraphase_workstation']['daisydisk']['license']['customer_name'].nil? && ! node['lyraphase_workstation']['daisydisk']['license']['registration_key'].nil?
  license_data = node['lyraphase_workstation']['daisydisk']['license']
end

template File.join(app_supportdir, 'DaisyDisk', 'License.DaisyDisk') do
  source "License.DaisyDisk.erb"
  owner node['lyraphase_workstation']['user']
  variables :license => license_data
  not_if { license_data.nil? }
end
