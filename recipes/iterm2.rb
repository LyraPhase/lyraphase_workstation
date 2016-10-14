# -*- coding: utf-8 -*-
#
# Copyright (C) 2016 James Cuzella
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

homebrew_cask 'iterm2'

template "/Users/#{node['lyraphase_workstation']['user']}/Library/Preferences/com.googlecode.iterm2.plist" do
  source "com.googlecode.iterm2.plist.erb"
  user node['lyraphase_workstation']['user']
  mode "0600"
  variables(
    :user => node['lyraphase_workstation']['user'],
    :home => node['lyraphase_workstation']['home']
  )
end
