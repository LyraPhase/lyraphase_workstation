#
# Cookbook Name:: lyraphase_workstation
# Recipe:: sublime_text_license
# Site:: http://www.sublimetext.com/
#
# Copyright (C) 2015-2019 James Cuzella
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

node['lyraphase_workstation']['sublime_text_settings']['shared_files'].each do |shared_sublime_file|
  symlink_target = "#{node['lyraphase_workstation']['sublime_text_settings']['shared_files_path']}/#{shared_sublime_file}"
  Chef::Log::warn("Sublime Text Settings file not found: #{symlink_target}") if !::File.exist?( symlink_target )

  symlink_path = "#{node['lyraphase_workstation']['sublime_text_settings']['app_support_path']}/#{shared_sublime_file}"
  directory symlink_path do
    action :delete
    only_if { !::File.symlink?( symlink_path ) && (::File.exist?( symlink_path ) || ::Dir.exist?( symlink_path )) }
    # Avoid deleting the dir if our symlink target shared file does not exist.
    not_if { !::File.exist?( symlink_target ) }
  end


  link symlink_path do
    to symlink_target
    owner node['lyraphase_workstation']['user']
    mode '0755'
    not_if { File.symlink?( symlink_target ) }
  end
end

