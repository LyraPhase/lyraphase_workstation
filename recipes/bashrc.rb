# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: bashrc
# Site:: https://www.gnu.org/software/bash/
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

bashrc_path = Pathname.new(File.join(node['lyraphase_workstation']['home'], '.bashrc'))
bash_logout_path = Pathname.new(File.join(node['lyraphase_workstation']['home'], '.bash_logout'))

homebrew_github_api_token = begin
                              data_bag_item('lyraphase_workstation', 'bashrc')['homebrew_github_api_token']
                            rescue
                              nil
                            end

if homebrew_github_api_token.nil? && !node['lyraphase_workstation']['bashrc']['homebrew_github_api_token'].nil? && !node['lyraphase_workstation']['bashrc']['homebrew_github_api_token'].nil?
  homebrew_github_api_token = node['lyraphase_workstation']['bashrc']['homebrew_github_api_token']
end

template bashrc_path do
  source 'bashrc.erb'
  user node['lyraphase_workstation']['user']
  mode '0644'
  variables(user_home: node['lyraphase_workstation']['home'],
            user_fullname: node['lyraphase_workstation']['bashrc']['user_fullname'],
            user_email: node['lyraphase_workstation']['bashrc']['user_email'],
            user_gpg_keyid: node['lyraphase_workstation']['bashrc']['user_gpg_keyid'],
            homebrew_github_api_token: homebrew_github_api_token
           )
end

template bash_logout_path do
  source 'bash_logout.erb'
  user node['lyraphase_workstation']['user']
  mode '0644'
  # No vars needed for now
end
