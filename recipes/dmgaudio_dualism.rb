#
# Cookbook Name:: lyraphase_workstation
# Recipe:: dmgaudio_dualism
# Site:: http://www.dmgaudio.com/products_dualism.php
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

zip_file = node['lyraphase_workstation']['dmgaudio_dualism']['zip']

remote_file "#{Chef::Config[:file_cache_path]}/#{zip_file['file_name']}" do
  owner node['sprout']['user']
  group 'staff'
  mode '0644'
  source zip_file['source']
  checksum zip_file['checksum']
  action :create_if_missing
end

bash "unpack #{zip_file['file_name']}" do
   code "unzip -o -d #{Chef::Config[:file_cache_path]}/ #{Chef::Config[:file_cache_path]}/#{zip_file['file_name']}"
   not_if {
     File.exists?("#{Chef::Config[:file_cache_path]}/#{zip_file['pkg_file']}")
   }
end

bash "Install DMGAudio Dualism" do
  code "installer -allowUntrusted -package  #{Chef::Config[:file_cache_path]}/#{zip_file['pkg_file']} -target /"
  not_if {
    require 'chef/mixin/shell_out'
    if shell_out("pkgutil --pkgs='#{zip_file['package_id']}'").exitstatus == 0
      Chef::Log.info "Already installed; to upgrade, try \"sudo pkgutil --forget '#{zip_file['package_id']}'\""
      true
    else
      false
    end
  }
end

ruby_block "test that DMGAudio Dualism install worked" do
  block do
    raise "Dualism install failed!" if ! zip_file['app_paths'].all? { |app_path| File.exists?(app_path) }
  end
end
