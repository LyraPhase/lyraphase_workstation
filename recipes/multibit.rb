# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: multibit
# Site:: https://multibit.org/
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2013-2022 James Cuzella
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
dmg_properties = node['sprout']['multibit']['dmg']

dmg_package 'MultiBit' do
  volumes_dir dmg_properties['volumes_dir']
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  type        dmg_properties['type']
  action :install
  owner node['lyraphase_workstation']['user']
end
