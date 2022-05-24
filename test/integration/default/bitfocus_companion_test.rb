# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook Name:: lyraphase_workstation
# Recipe:: bitfocus_companion
# Site:: https://bitfocus.io/companion/download/mac/
#
# License:: GPL-3.0+
# Copyright (C) © 🄯 2022 James Cuzella
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

# InSpec test for recipe lyraphase_workstation::bitfocus_companion

app = 'Companion.app'
app_bundle_id_regex = /^companion\.bitfocus\.no/

test_kitchen_user = input('test_kitchen_user', value: 'kitchen')
applications_path = '/Applications'
app_path = File.join(applications_path, app)
get_bundle_id_cmd = "sudo su -m #{test_kitchen_user} -c 'osascript -e '\\''id of app \"#{app}\"'\\'''"
executable_path = File.join(app_path, 'Contents', 'MacOS', 'Companion')
node_arch = command('uname -m').stdout.chomp

describe file(app_path) do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
  its('owner') { should eq test_kitchen_user }
end

describe command(get_bundle_id_cmd) do
  its('exit_status') { should eq 0 }
  its('stdout') { should match app_bundle_id_regex }
  its('stderr') { should eq '' }
end

describe command("file '#{executable_path}'") do
  its('exit_status') { should eq 0 }
  its('stdout') { should match Regexp.new(".*#{node_arch}.*") }
  its('stderr') { should eq '' }
end
