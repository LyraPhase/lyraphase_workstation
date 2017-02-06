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

homebrew_tap 'homebrew/versions'

if ! node.attribute?(node['homebrew']['formulas'])
  node.default['homebrew']['formulas'] = []
end

unless node['homebrew']['formulas'].include?('gnupg21')
  node.default['homebrew']['formulas'].push('gnupg21')
end

# Unlink all MacGPG binaries from /usr/local/bin
# gnupg21 Homebrew formula will link these to our gpg2 version
if ( (!node['lyraphase_workstation']['gpg21']['binary_paths'].nil?) rescue false)
  node['lyraphase_workstation']['gpg21']['binary_paths'].each do |binary_symlink|
    link binary_symlink do
      action :delete
      only_if "test -L #{binary_symlink} && readlink #{binary_symlink} | grep -qi 'MacGPG'"
    end
  end
end

include_recipe "homebrew::install_formulas"

gpgtools_launchagent_domain = nil
gpgtools_launchagent_plist_file = nil
if ! node['lyraphase_workstation']['gpg21'].nil? && ! node['lyraphase_workstation']['gpg21']['gpgtools_plist_file'].nil?
  gpgtools_launchagent_plist_file = node['lyraphase_workstation']['gpg21']['gpgtools_plist_file']
  gpgtools_launchagent_domain = File.basename(gpgtools_launchagent_plist_file).gsub(/\.plist$/, '')
  gpgtools_launchagent_plist_file = Pathname.new(gpgtools_launchagent_plist_file)
end

template "/usr/local/bin/fixGpgHome" do
  source "fixGpgHome.erb"
  user node['lyraphase_workstation']['user']
  mode "0755"
  # No variables for now
end

template "/Library/LaunchAgents/com.lyraphase.gpg21.fix.plist" do
  source "com.lyraphase.gpg21.fix.plist.erb"
  user node['lyraphase_workstation']['user']
  mode "0644"
  # No variables for now
end

plist_file gpgtools_launchagent_plist_file do
  file gpgtools_launchagent_plist_file if ! gpgtools_launchagent_plist_file.nil?
  domain gpgtools_launchagent_domain if ! gpgtools_launchagent_domain.nil?
  set "RunAtLoad", false
  owner 'root'
  group 'wheel'
  mode 0600
  action :update
end

ruby_block "add StreamLocalBindUnlink to sshd config" do
  block do
    add_streamlocalbindunlink_to_sshd_config
  end
end
