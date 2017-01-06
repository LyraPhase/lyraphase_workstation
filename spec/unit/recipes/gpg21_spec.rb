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


describe 'lyraphase_workstation::gpg21' do

  let(:launchd_plist) { "/Library/LaunchAgents/com.lyraphase.gpg21.fix.plist" }
  let(:fixGpgHome_script_path) { "/usr/local/bin/fixGpgHome" }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.11.1') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'
    end.converge(described_recipe)
  }

  it 'taps homebrew/versions' do
    expect(chef_run).to tap_homebrew_tap('homebrew/versions')
  end

  it 'installs gnugpg21 via homebrew' do
    expect(chef_run.node['homebrew']['formulas']).to include('gnupg21')
    expect(chef_run).to include_recipe('homebrew::install_formulas')
  end

  it 'installs fixGpgHome script for overriding gpg-agent & gpg2 from MacGPGTools' do
    expect(chef_run).to create_template(fixGpgHome_script_path).with(
      user:   'brubble',
      mode: '0755'
    )
    expect(chef_run).to render_file(fixGpgHome_script_path).with_content(/^.*\/usr\/local\/bin\/gpg-agent\s+--daemon.*$/)
    expect(chef_run).to_not render_file(fixGpgHome_script_path).with_content(/^.*\/usr\/local\/MacGPG2\/bin\/gpg-agent.*$/)
  end

  it 'installs launchd plist for launching fixGpgHome script' do
    expect(chef_run).to create_template(launchd_plist).with(
      user:   'brubble',
      mode: '0644'
    )
    expect(chef_run).to render_file(launchd_plist).with_content(Regexp.new("^\\s+<string>#{Regexp.escape(fixGpgHome_script_path)}</string>$"))
    expect(chef_run).to render_file(launchd_plist).with_content(Regexp.new("^\\s+<string>#{Regexp.escape(File.basename(launchd_plist).gsub(/\.plist$/, ''))}</string>$"))
  end

end

