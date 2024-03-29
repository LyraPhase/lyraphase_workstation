# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: homebrew_sudoers
# Site:: https://github.com/chef-cookbooks/homebrew/issues/105
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

directory '/etc/sudoers.d' do
  owner 'root'
  group 'wheel'
  mode '0755'
  action :create
end

template '/etc/sudoers.d/homebrew_chef' do
  owner 'root'
  group 'wheel'
  mode '0644'
  source 'sudoers.d/homebrew_chef.erb'
  variables(
    hostname: node['hostname'],
    user: node['lyraphase_workstation']['user']
  )
  action :create
end
