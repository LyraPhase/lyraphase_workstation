# -*- coding: utf-8 -*-
#
# Copyright (C) 2016-2017 James Cuzella
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

if ! node.attribute?(node['homebrew']['formulas'])
  node.default['homebrew']['formulas'] = []
end

unless has_formula_named?(node['homebrew']['formulas'], 'bash')
  node.default['homebrew']['formulas'].push('bash')
end

unless has_formula_named?(node['homebrew']['formulas'], 'bash-completion@2')
  node.default['homebrew']['formulas'].push('bash-completion@2')
end

package 'bash'
package 'bash-completion@2'

etc_shells = nil
etc_shells_path = nil
etc_shells_file = nil
if ! node['lyraphase_workstation']['bash'].nil? && ! node['lyraphase_workstation']['bash']['etc_shells'].nil?
  etc_shells = node['lyraphase_workstation']['bash']['etc_shells']
  etc_shells_path = node['lyraphase_workstation']['bash']['etc_shells_path']
  etc_shells_file = Pathname.new(etc_shells_path)
end

template etc_shells_file do
  source "etc_shells.erb"
  user node['lyraphase_workstation']['user']
  mode "0644"
  variables({ etc_shells: etc_shells })
end

