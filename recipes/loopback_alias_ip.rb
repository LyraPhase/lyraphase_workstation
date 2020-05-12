# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2018-2020 James Cuzella
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


loopback_alias_ip = nil
if ! node['lyraphase_workstation']['loopback_alias_ip'].nil? && ! node['lyraphase_workstation']['loopback_alias_ip']['alias_ip'].nil?
  loopback_alias_ip = node['lyraphase_workstation']['loopback_alias_ip']['alias_ip']
end

file "/var/log/loopback-alias.log" do
  action :create
  owner "root"
  group "wheel"
  mode "0664"
end

template "/Library/LaunchDaemons/com.runlevel1.lo0.alias.plist" do
  source "com.runlevel1.lo0.alias.plist.erb"
  user "root"
  group "wheel"
  mode "0644"
  variables({ loopback_alias_ip: loopback_alias_ip })
  notifies :run, 'execute[load the com.runlevel1.lo0.alias plist into launchd]'
end

execute "load the com.runlevel1.lo0.alias plist into launchd" do
  command "launchctl load -w /Library/LaunchDaemons/com.runlevel1.lo0.alias.plist"
  user "root"
  not_if 'sudo launchctl list com.runlevel1.lo0.alias'
end
