# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2016-2021 James Cuzella
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

user_default_shell = node['lyraphase_workstation']['user_default_shell']
if ! user_default_shell.nil? && ! user_default_shell['set_login_shell'].nil? && user_default_shell['set_login_shell'] && ! user_default_shell['shell'].nil?
  shell_regexp = Regexp.escape(user_default_shell['shell']).gsub('/', '\/')
  execute 'change login shell' do
    command "chsh -u #{node['lyraphase_workstation']['user']} -s #{node['lyraphase_workstation']['user_default_shell']['shell']}"
    user 'root'
    not_if "dscl /Search -read '/Users/#{node['lyraphase_workstation']['user']}' UserShell | grep -Eq '#{shell_regexp}'"
  end
end
