#
# Cookbook Name:: lyraphase_workstation
# Recipe:: musicbrainz_picard
# Site:: https://picard.musicbrainz.org/
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
dmg_properties = node['lyraphase_workstation']['musicbrainz_picard']['dmg']

dmg_package "MusicBrainz Picard" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  owner       node['lyraphase_workstation']['user']
  type 'app'
  #package_id  'com.native-instruments.Traktor2.*'
end
