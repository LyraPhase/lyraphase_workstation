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
    klass.new(platform: 'mac_os_x', version: '10.15') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      require 'securerandom'
      node.normal['lyraphase_workstation']['bashrc']['homebrew_github_api_token'] = SecureRandom.hex(20)
      node.normal['lyraphase_workstation']['bashrc']['user_fullname'] = 'Barney Rubble'
      node.normal['lyraphase_workstation']['bashrc']['user_email'] = 'barney.rubble@lyraphase.com'
      node.normal['lyraphase_workstation']['bashrc']['user_gpg_keyid'] = "0x#{SecureRandom.hex(8)}"

    end.converge(described_recipe)
  }

  it 'installs custom .bashrc into user homedir' do
    expect(chef_run).to create_template(bashrc_path).with(
      user:   'brubble',
      mode: '0644'
    )

    [ "export HOMEBREW_GITHUB_API_TOKEN='#{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_github_api_token']}'",
      "export DEBFULLNAME='#{chef_run.node['lyraphase_workstation']['bashrc']['user_fullname']}'",
      "export DEBEMAIL='#{chef_run.node['lyraphase_workstation']['bashrc']['user_email']}'",
      "export DEBSIGN_KEYID='#{chef_run.node['lyraphase_workstation']['bashrc']['user_gpg_keyid']}'",
    ].each do |expected_regex|
      expect(chef_run).to render_file(bashrc_path).with_content(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
    end
  end

end

