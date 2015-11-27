#
# Cookbook Name:: lyraphase_workstation
# Recipe:: sublime_text_license
# Site:: http://www.sublimetext.com/
#
# Copyright (C) 2015 James Cuzella
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

[ "Installed Packages", "Packages", "Local/License.sublime_license" ].each do |shared_sublime_file|
  symlink_target = "#{node['lyraphase_workstation']['home']}/Dropbox/AppData/mac/sublime-text-3/#{shared_sublime_file}"
  Chef::Log::warn("Sublime Text Settings file not found: #{symlink_target}") if File.exist?("symlink_target")

  link "#{node['lyraphase_workstation']['home']}/Library/Application Support/Sublime Text 3/#{shared_sublime_file}" do
    to symlink_target
    owner node['lyraphase_workstation']['user']
    not_if { File.symlink?( symlink_target ) }
  end
end

