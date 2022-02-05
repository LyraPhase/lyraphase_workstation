# -*- coding: utf-8 -*-
# frozen_string_literal: true

#
# Cookbook:: lyraphase_workstation
# Recipe:: bash4
# Site:: https://www.gnu.org/software/bash/
#
# License:: GPL-3.0+
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

node.default['homebrew']['formulas'] = [] unless node.attribute?(node['homebrew']['formulas'])

node.default['homebrew']['formulas'].push('bash') unless has_formula_named?(node['homebrew']['formulas'], 'bash')

unless has_formula_named?(node['homebrew']['formulas'], 'bash-completion@2')
  node.default['homebrew']['formulas'].push('bash-completion@2')
end

package 'bash'
package 'bash-completion@2'

# rubocop:disable Lint/UselessAssignment
etc_shells = nil
etc_shells_path = nil
etc_shells_file = nil
# rubocop:enable Lint/UselessAssignment
if !node['lyraphase_workstation']['bash'].nil? && !node['lyraphase_workstation']['bash']['etc_shells'].nil?
  etc_shells = node['lyraphase_workstation']['bash']['etc_shells']
  etc_shells_path = node['lyraphase_workstation']['bash']['etc_shells_path']
  etc_shells_file = Pathname.new(etc_shells_path)
end

template etc_shells_file do
  source 'etc_shells.erb'
  user node['lyraphase_workstation']['user']
  mode '0644'
  variables(etc_shells: etc_shells)
end

attributes_not_nil =
  !node['lyraphase_workstation']['bash'].nil? &&
  !node['lyraphase_workstation']['bash']['set_login_shell'].nil? &&
  node['lyraphase_workstation']['bash']['set_login_shell']
if attributes_not_nil
  execute 'change login shell to homebrew bash4' do
    command "chsh -s -u #{node['lyraphase_workstation']['user']} /usr/local/bin/bash"
    user 'root'
    # rubocop:disable Metrics/LineLength
    not_if "dscl /Search -read '/Users/#{node['lyraphase_workstation']['user']}' UserShell | grep -q '\/usr\/local\/bin\/bash'"
    # rubocop:enable Metrics/LineLength
  end
end
