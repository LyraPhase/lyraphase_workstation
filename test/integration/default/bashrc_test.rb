# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook Name:: lyraphase_workstation
# Recipe:: bashrc
# Site:: https://www.gnu.org/software/bash/
#
# Copyright (C) © 🄯 2016-2022 James Cuzella
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

# InSpec test for recipe lyraphase_workstation::bashrc

test_kitchen_user = input('test_kitchen_user', value: 'kitchen')
bashrc_path = "/Users/#{test_kitchen_user}/.bashrc"
bash_logout_path = "/Users/#{test_kitchen_user}/.bash_logout"
homebrew_github_api_token = 'gh_f00dcafevagrant'

describe file(bashrc_path) do
  it { should exist }
  it { should be_file }
  its('mode') { should cmp '0644' }
  its('owner') { should eq test_kitchen_user }

  its('content') { should match Regexp.new("^\s*export HOMEBREW_GITHUB_API_TOKEN='#{homebrew_github_api_token}'") }
  its('content') { should match /^\s*export DEBFULLNAME='vagrant'$/ }
  its('content') { should match /^\s*export DEBEMAIL='vagrant@vagrant.com'$/ }
  its('content') { should match /^\s*export DEBSIGN_KEYID='0xBADC0DE00FEED000'$/ }

end

describe file(bash_logout_path) do
  it { should exist }
  it { should be_file }
  its('owner') { should eq test_kitchen_user }
  its('mode') { should cmp '0644' }
end
