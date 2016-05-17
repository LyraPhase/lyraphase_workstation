# -*- coding: utf-8 -*-
#
# Cookbook Name:: lyraphase_workstation
# Recipe:: airfoil
# Site:: https://www.rogueamoeba.com/airfoil/
#
# Copyright (C) 2016 James Cuzella
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

homebrew_cask "airfoil"

license_info = Chef::EncryptedDataBagItem.load('lyraphase_workstation', 'airfoil') rescue nil
if license_info.nil? && ! node['lyraphase_workstation']['airfoil'].nil? && ! node['lyraphase_workstation']['airfoil']['license'].nil? && ! node['lyraphase_workstation']['airfoil']['license']['name'].nil? && ! node['lyraphase_workstation']['airfoil']['license']['code'].nil?
  license_info = node['lyraphase_workstation']['airfoil']['license']
end

airfoil_domain = nil
airfoil_plist_file = nil

if ! node['lyraphase_workstation']['airfoil']['plist_file'].nil?
  airfoil_plist_file = Pathname.new(node['lyraphase_workstation']['airfoil']['plist_file'].to_s)
  airfoil_plist_resource_name = airfoil_plist_file.basename
else
  airfoil_plist_file = Pathname.new("#{node['lyraphase_workstation']['home']}/Library/Preferences/com.rogueamoeba.Airfoil.plist")
  airfoil_domain = 'com.rogueamoeba.Airfoil'
  airfoil_plist_resource_name = "#{airfoil_domain}.plist"
end

plist_file airfoil_plist_resource_name do
  file airfoil_plist_file if ! airfoil_plist_file.nil?
  set "registrationInfo", { "Code" => license_info['code'].to_s, "Name" => license_info['name'].to_s } if ! license_info.nil?
  domain airfoil_domain if ! airfoil_domain.nil?
  owner node['lyraphase_workstation']['user']
  mode 0600
  action :update
end
