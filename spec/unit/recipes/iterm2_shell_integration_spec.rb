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

require 'spec_helper'


describe 'lyraphase_workstation::iterm2_shell_integration' do

  let(:src_filename) { 'iterm2_install_shell_integration.sh' }
  let(:src_filepath) { "#{Chef::Config['file_cache_path']}/#{src_filename}" }
  let(:user_shell) { user_shell = 'bash' }
  let(:installed_script_path) { File.join('/Users/brubble', ".iterm2_shell_integration.#{user_shell}") }
  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'
    end.converge(described_recipe)
  }

  it 'installs iTerm2 + plist via lyraphase_workstation::iterm2' do
    expect(chef_run).to create_remote_file(src_filepath).with(owner: 'brubble', mode: '0755')
    expect(chef_run).to include_recipe 'lyraphase_workstation::iterm2'
  end

  it 'installs iTerm2 Shell Integration' do
    expect(chef_run).to create_remote_file(src_filepath).with(owner: 'brubble', mode: '0755')
    expect(chef_run).to run_bash('install iterm2 shell integration').with(creates: installed_script_path, code: src_filepath)
  end
end

