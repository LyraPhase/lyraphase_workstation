# -*- coding: utf-8 -*-
#
# Copyright (C) 2015-2017 James Cuzella
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

describe 'lyraphase_workstation::homebrew_sudoers' do

  # before(:all) do
  #   # To use GitHub for latest platform (customink/fauxhai#201)
  #   # edge: true
  #   Fauxhai.mock(platform:'mac_os_x', version:'10.11') do |node|
  #     node['hostname'] = 'bedrock'
  #     Chef::Log.warn("INSIDE ChefSpec: node['hostname'] = #{node['hostname']}")
  #     # node['lyraphase_workstation']['user'] = 'brubble'
  #   end
  # end

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.default['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.default['lyraphase_workstation']['user'] = 'brubble'
      node.default['lyraphase_workstation']['home'] = '/Users/brubble'
      node.automatic['hostname'] = 'bedrock'
    end.converge(described_recipe)
  }


  it 'creates /etc/sudoers.d directory' do
    expect(chef_run).to create_directory('/etc/sudoers.d').with(
      user:  'root',
      group: 'wheel',
      mode:  '0755'
    )
  end

  let(:expected_commands) {
    [
      '/bin/chmod',
      '/usr/sbin/chown',
      '/bin/mkdir',
      '/usr/bin/chgrp',
      '/usr/bin/touch',
      '/usr/sbin/softwareupdate',
      '/bin/rm',
      '/usr/sbin/installer',
      '/usr/bin/env'
    ]
  }

  it 'installs /etc/sudoers.d/homebrew_chef' do
    expect(chef_run).to create_template('/etc/sudoers.d/homebrew_chef').with(
      user:  'root',
      group: 'wheel',
      mode:  '0644'
    )
    expected_commands.each do |expected_command|
      expect(chef_run).to render_file('/etc/sudoers.d/homebrew_chef').with_content(
        Regexp.new("^brubble\\s+bedrock=\\(root\\)\\s+NOPASSWD:SETENV:\\s+#{expected_command}$")
      )
    end
  end
end

