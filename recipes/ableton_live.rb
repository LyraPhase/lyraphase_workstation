# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: ableton_live
# Site:: https://www.ableton.com/
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2013-2020 James Cuzella
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
# rubocop:disable Style/ClassCheck
raise "Attribute: node['lyraphase_workstation'] is not defined well, should be a kind of Hash" unless node['lyraphase_workstation'].kind_of?(Hash)
raise "Attribute: node['lyraphase_workstation']['ableton_live'] is not defined well, should be a kind of Hash" unless node['lyraphase_workstation']['ableton_live'].kind_of?(Hash)
raise "Attribute: node['lyraphase_workstation']['ableton_live']['dmg'] is not defined well, should be a kind of Hash" unless node['lyraphase_workstation']['ableton_live']['dmg'].kind_of?(Hash)
# rubocop:enable Style/ClassCheck

dmg_properties = node['lyraphase_workstation']['ableton_live']['dmg']

dmg_package 'Ableton Live' do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  dmg_name    dmg_properties['dmg_name']
  app         dmg_properties['app']
  type        dmg_properties['type']
  owner       node['lyraphase_workstation']['user']
  accept_eula true
  action :install
end
