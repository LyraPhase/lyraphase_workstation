# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: osx_autohide_dock
# Manual:: https://developer.apple.com/documentation/devicemanagement/dock
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2015-2022 James Cuzella
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
if node['lyraphase_workstation']['settings']['autohide_delay']
  osx_defaults "Enable AutoHide OSX Dock (delay = #{node['lyraphase_workstation']['settings']['autohide_delay'].to_f})" do
    domain 'com.apple.dock'
    key 'autohide-delay'
    float node['lyraphase_workstation']['settings']['autohide_delay'].to_f
  end
end

osx_defaults 'Enable AutoHide OSX Dock' do
  domain 'com.apple.dock'
  key 'autohide'
  bool node['lyraphase_workstation']['settings']['autohide_dock'].to_bool
end
