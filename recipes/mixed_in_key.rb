# -*- coding: utf-8 -*-
# frozen_string_literal: true

#
# Cookbook:: lyraphase_workstation
# Recipe:: mixed_in_key
# Site:: http://www.mixedinkey.com
#
# Copyright:: (C) © 🄯  2013-2021 James Cuzella
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
dmg_properties = node['lyraphase_workstation']['mixed_in_key']['dmg']

dmg_package 'Mixed In Key' do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  dmg_name    dmg_properties['dmg_name']
  app         dmg_properties['app']
  type        dmg_properties['type']
  owner       node['lyraphase_workstation']['user']
  action :install
end

# rubocop:disable Style/RescueModifier
license_key_data = data_bag_item('lyraphase_workstation', 'mixed_in_key')['license'] rescue nil
# rubocop:enable Style/RescueModifier

license_key_data_complete =
  license_key_data.nil? &&
  !node['lyraphase_workstation']['mixed_in_key']['license'].nil? &&
  !node['lyraphase_workstation']['mixed_in_key']['license']['vipcode']
license_key_data = node['lyraphase_workstation']['mixed_in_key']['license'] if license_key_data_complete

# Install VIPCode via plist
unless license_key_data.nil? && license_key_data['vipcode'].nil?
  plist_path = File.expand_path(
    'com.mixedinkey.application.plist',
    File.join(node['lyraphase_workstation']['home'], 'Library', 'Preferences')
  )
  template plist_path do
    source 'com.mixedinkey.application.plist.erb'
    owner node['lyraphase_workstation']['user']
    variables(
      vipcode: license_key_data['vipcode']
    )
  end
end
