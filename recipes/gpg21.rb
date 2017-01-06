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

include_recipe "homebrew::install_formulas"

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