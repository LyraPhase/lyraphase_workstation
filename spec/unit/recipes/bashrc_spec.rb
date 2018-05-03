# -*- coding: utf-8 -*-
#
# Copyright (C) 2016-2018 James Cuzella
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

describe 'lyraphase_workstation::bashrc' do

  let(:bashrc_path) { '/Users/brubble/.bashrc' }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.11.1') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      stub_command("dscl /Search -read '/Users/brubble' UserShell | grep -q '\/usr\/local\/bin\/bash'").and_return(false)
    end.converge(described_recipe)
  }

  it 'installs custom .bashrc into user homedir' do
    expect(chef_run).to create_file(bashrc_path).with(
      user:   'brubble',
      mode: '0644'
    )

    expect(chef_run).to render_file(bashrc_path) #.with_content()
  end

end

