#
# Cookbook Name:: lyraphase_workstation
# Recipe:: prolific_pl2303_driver
# Site:: http://www.prolific.com.tw/US/ShowProduct.aspx?p_id=229&pcid=41
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
#

zip_file = node['lyraphase_workstation']['prolific_pl2303_driver']['zip']

remote_file "#{Chef::Config[:file_cache_path]}/#{zip_file['file_name']}" do
  owner node['lyraphase_workstation']['user']
  group 'staff'
  mode '0644'
  source zip_file['source']
  checksum zip_file['checksum']
  action :create_if_missing
end

bash "unpack #{zip_file['file_name']}" do
   code "unzip -o -d #{Chef::Config[:file_cache_path]}/ #{Chef::Config[:file_cache_path]}/#{zip_file['file_name']} '*.pkg'"
   not_if {
     File.exists?("#{Chef::Config[:file_cache_path]}/#{zip_file['pkg_file']}")
   }
end

bash "Install Prolific PL2303 Driver" do
  code "installer -allowUntrusted -package  #{Chef::Config[:file_cache_path]}/#{zip_file['pkg_file']} -target /"
  not_if {
    Chef::Recipe::PkgPackage::pkg_installed?(zip_file['package_id'])
  }
end

ruby_block "test that Prolific PL2303 Driver install worked" do
  block do
    raise "Prolific PL2303 Driver install failed!" if ! zip_file['app_paths'].all? { |app_path| File.exists?(app_path) }
  end
end

