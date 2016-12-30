# -*- coding: utf-8 -*-
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


include_recipe 'lyraphase_workstation::iterm2'

src_filename = 'iterm2_install_shell_integration.sh'
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"

user_shell = File.basename(node['etc']['passwd'][node['lyraphase_workstation']['user']]['shell']) || 'bash'
installed_script_path = File.join(node['lyraphase_workstation']['home'], ".iterm2_shell_integration.#{user_shell}")

remote_file src_filepath do
  source node['lyraphase_workstation']['iterm2_shell_integration']['url']
  checksum node['lyraphase_workstation']['iterm2_shell_integration']['checksum']
  owner node['lyraphase_workstation']['user']
  mode '0755'
end

# The install script is written for bash, but the shell integration will detect the user's $SHELL
bash 'install iterm2 shell integration' do
  cwd ::File.dirname(src_filepath)
  user node['lyraphase_workstation']['user']
  code src_filepath
  creates installed_script_path
end
