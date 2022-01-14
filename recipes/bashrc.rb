# -*- coding: utf-8 -*-
#
# Copyright (C) 2016-2018 James Cuzella
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

homebrew_github_api_token = data_bag_item('lyraphase_workstation', 'bashrc')['homebrew_github_api_token'] rescue nil

if homebrew_github_api_token.nil? && ! node['lyraphase_workstation']['bashrc']['homebrew_github_api_token'].nil? && ! node['lyraphase_workstation']['bashrc']['homebrew_github_api_token'].nil?
  homebrew_github_api_token = node['lyraphase_workstation']['bashrc']['homebrew_github_api_token']
end


template bashrc_path do
  source "bashrc.erb"
  user node['lyraphase_workstation']['user']
  mode "0644"
  variables({ user_home: node['lyraphase_workstation']['home'],
    user_fullname:  node['lyraphase_workstation']['bashrc']['user_fullname'],
    user_email:     node['lyraphase_workstation']['bashrc']['user_email'],
    user_gpg_keyid: node['lyraphase_workstation']['bashrc']['user_gpg_keyid'],
    homebrew_github_api_token: homebrew_github_api_token
  })
end
