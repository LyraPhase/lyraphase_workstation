# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: sublime_text_license
# Site:: http://www.sublimetext.com/
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

unless File.exists?(node['lyraphase_workstation']['sublime_text_settings']['shared_files_path'])
  Chef::Log.warn('pCloud Drive installation cannot be automated... please Enable Drive and allow kernel extensions from Recovery mode.')
  Chef::Log.warn('  https://web.archive.org/web/20211221010410/https://blog.pcloud.com/how-to-install-pcloud-drive-on-apple-devices-with-the-m1-chip/')
  Chef::Log.warn('Sublime Text shared_files_path may not exist until pCloud Drive is enabled!')
end

node['lyraphase_workstation']['sublime_text_settings']['shared_files'].each do |shared_sublime_file|
  symlink_target =
    "#{node['lyraphase_workstation']['sublime_text_settings']['shared_files_path']}/#{shared_sublime_file}"
  Chef::Log.warn("Sublime Text Settings file not found: #{symlink_target}") unless ::File.exist?(symlink_target)

  symlink_path = "#{node['lyraphase_workstation']['sublime_text_settings']['app_support_path']}/#{shared_sublime_file}"

  # Create recursive directories specified in shared_files
  # under app_support_path, except special cases: '.' '..' '/'
  shared_sublime_file_parent_dir = File.dirname(shared_sublime_file)
  if !['.', '..', '/'].include?(shared_sublime_file_parent_dir)
    symlink_path_parent_dir = File.dirname(Pathname.new(symlink_path))
    directory symlink_path_parent_dir do
      action :create
      recursive true
      owner node['lyraphase_workstation']['user']
      group 'staff'
      mode '0700'
      # Avoid creating the dir if our symlink target shared file does not exist.
      not_if { !::File.exist?( symlink_target ) }
    end
  end

  directory symlink_path do
    action :delete
    only_if { !::File.symlink?(symlink_path) && (::File.exist?(symlink_path) || ::Dir.exist?(symlink_path)) }
    # Avoid deleting the dir if our symlink target shared file does not exist.
    not_if { !::File.exist?(symlink_target) }
  end

  link symlink_path do
    to symlink_target
    owner node['lyraphase_workstation']['user']
    mode '0755'
    not_if { File.symlink?(symlink_target) }
  end
end
