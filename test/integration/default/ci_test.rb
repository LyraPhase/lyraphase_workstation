# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook Name:: lyraphase_workstation
# Recipe:: N/A
# Site:: https://lyraphase.com/
#
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

# InSpec test for GitHub Actions CI Workflow

describe command('/usr/bin/false') do
  its('exit_status') { should eq 0 }
  its('stdout') { should eq 'simluate-failure' }
  its('stderr') { should eq '' }
end
