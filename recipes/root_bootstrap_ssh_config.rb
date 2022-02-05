# -*- coding: utf-8 -*-
# frozen_string_literal: true

#
# Cookbook:: lyraphase_workstation
# Recipe:: root_bootstrap_ssh_config
# License:: GPLv3
# Copyright:: (C) © 🄯  2016-2021 James Cuzella
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

directory '/var/root/.ssh' do
  owner 'root'
  group 'wheel'
  mode '0700'
  action :create
end

file '/var/root/.ssh/known_hosts' do
  action :create_if_missing
  owner 'root'
  group 'wheel'
  mode '0644'
end

execute 'add github to known_hosts' do
  user 'root'
  cwd '/var/root/.ssh'
  command <<-SH
    echo 'github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' >> known_hosts
  SH
  not_if 'grep -q github.com known_hosts'
end

template '/var/root/.ssh/config' do
  source 'ssh/root_bootstrap_ssh_config.erb'
  user 'root'
  group 'wheel'
  mode '0600'
  variables(
    home: node['lyraphase_workstation']['home'],
    identity_file: node['lyraphase_workstation']['root_bootstrap_ssh_config']['identity_file']
  )
end
