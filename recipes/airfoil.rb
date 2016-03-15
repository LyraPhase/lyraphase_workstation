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

license_info = node['lyraphase_workstation']['airfoil']['license']

if node['lyraphase_workstation']['airfoil']['plist_file']
  airfoil_plist_file = node['lyraphase_workstation']['airfoil']['plist_file']
else
  airfoil_plist_file = Pathname.new("#{node['sprout']['home']}/Library/Preferences/com.rogueamoeba.Airfoil.plist")
end

plist_file airfoil_plist_file.basename do
  file airfoil_plist_file
  push "registrationInfo", "Code", license_info['code'].to_s
  push "registrationInfo", "Name", license_info['name'].to_s
  owner node['lyraphase_workstation']['user']
  mode "0600"
  action :update
end
