# -*- coding: utf-8 -*-
#
# Copyright (C) 2018 James Cuzella
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


ssh_tunnel_port_override = nil
if ! node['lyraphase_workstation']['ssh_tunnel_port_override'].nil?
  ssh_tunnel_port_override = node['lyraphase_workstation']['ssh_tunnel_port_override']
end

file "/var/log/ssh-tunnel-port-override.log" do
  action :create
  owner "root"
  group "wheel"
  mode "0664"
end

template ssh_tunnel_port_override['script'] do
  source "ssh-tunnel-port-override.sh.erb"
  user node['lyraphase_workstation']['user']
  group "wheel"
  mode "0755"
  variables({ ssh_tunnel_port_override_portnumber: ssh_tunnel_port_override['port'] })
end

template "/Library/LaunchDaemons/com.lyraphase.ssh-tunnel-port-override.plist" do
  source "com.lyraphase.ssh-tunnel-port-override.plist.erb"
  user "root"
  group "wheel"
  mode "0644"
  variables({ ssh_tunnel_port_override_script: ssh_tunnel_port_override['script'] })
  notifies :run, 'execute[load the com.lyraphase.ssh-tunnel-port-override plist into launchd]'
end

execute "load the com.lyraphase.ssh-tunnel-port-override plist into launchd" do
  command "launchctl load -w /Library/LaunchDaemons/com.lyraphase.ssh-tunnel-port-override.plist"
  user "root"
  not_if 'sudo launchctl list com.lyraphase.ssh-tunnel-port-override'
end
