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
bash_profile_path = Pathname.new(File.join(node['lyraphase_workstation']['home'], '.bash_profile'))

# Gather Homebrew GitHub token from encrypted data bag
homebrew_github_api_token_data =  begin
                                    data_bag_item('lyraphase_workstation', 'bashrc')
                                  rescue
                                    nil
                                  end

loaded_data = !homebrew_github_api_token_data.nil? ? homebrew_github_api_token_data.to_hash : Hash.new()
homebrew_github_api_token_hash = Hash.new()
['homebrew_github_api_token', 'homebrew_github_api_token_comment'].each do |data_bag_key|
  if !homebrew_github_api_token_data.nil? && loaded_data.has_key?(node['name']) && loaded_data[node['name']].has_key?(data_bag_key)
    Chef::Log.info("Loading Homebrew GitHub API token for Node Name: #{node['name']}")
    homebrew_github_api_token_hash[data_bag_key] = begin
                                  homebrew_github_api_token_data[node['name']][data_bag_key]
                                rescue
                                  nil
                                end
  end

  if homebrew_github_api_token_hash[data_bag_key].nil? && !node['lyraphase_workstation']['bashrc'][data_bag_key].nil?
    homebrew_github_api_token_hash[data_bag_key] = node['lyraphase_workstation']['bashrc'][data_bag_key]
  end

  if homebrew_github_api_token_hash[data_bag_key].nil? && !homebrew_github_api_token_data.nil?
    Chef::Log.warn("Could not find Homebrew GitHub API token attribute #{data_bag_key} in data bag item lyraphase_workstation:bashrc for Node Name: #{node['name']}")
    Chef::Log.warn("Expected Data Bag Item Schema: {\"id\": \"bashrc\", \"#{node['name']}\": {\"homebrew_github_api_token\": \"gh_f00dcafevagrant\", \"homebrew_github_api_token_comment\": \"some optional comment\"}}")
  end
end

if !node['lyraphase_workstation']['bashrc']['homebrew_no_cleanup_formulae'].nil?
  homebrew_no_cleanup_formulae = node['lyraphase_workstation']['bashrc']['homebrew_no_cleanup_formulae']
end

template bashrc_path do
  source 'bashrc.erb'
  user node['lyraphase_workstation']['user']
  mode '0644'
  variables(user_home: node['lyraphase_workstation']['home'],
            user_fullname: node['lyraphase_workstation']['bashrc']['user_fullname'],
            user_email: node['lyraphase_workstation']['bashrc']['user_email'],
            user_gpg_keyid: node['lyraphase_workstation']['bashrc']['user_gpg_keyid'],
            homebrew_github_api_token: homebrew_github_api_token_hash['homebrew_github_api_token'],
            homebrew_github_api_token_comment: homebrew_github_api_token_hash['homebrew_github_api_token_comment'],
            homebrew_no_cleanup_formulae: homebrew_no_cleanup_formulae
           )
end

template bash_logout_path do
  source 'bash_logout.erb'
  user node['lyraphase_workstation']['user']
  mode '0644'
  # No vars needed for now
end

template bash_profile_path do
  source 'bash_profile.erb'
  user node['lyraphase_workstation']['user']
  mode '0644'
  variables(user_home: node['lyraphase_workstation']['home'])
end
