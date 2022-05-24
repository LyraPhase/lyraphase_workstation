# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2018-2020 James Cuzella
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

describe 'lyraphase_workstation::loopback_alias_ip' do

  let(:launchd_plist) { "/Library/LaunchDaemons/com.runlevel1.lo0.alias.plist" }
  let(:loopback_alias_log) { "/var/log/loopback-alias.log" }
  let(:loopback_alias_ip) { '172.16.222.111' }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.11') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      stub_command("which git").and_return('/usr/local/bin/git')

      stub_command('launchctl list com.runlevel1.lo0.alias').and_return(true)
      stub_command("sudo launchctl list com.runlevel1.lo0.alias").and_return(true)
    end.converge(described_recipe)
  }

  it 'creates log file for loopback-alias service' do
    expect(chef_run).to create_file(loopback_alias_log).with(
      user:   'root',
      group:  'wheel',
      mode:   '0664'
    )
  end

  it 'installs launchd plist for adding IP alias to loopback network interface lo0' do
    expect(chef_run).to create_template(launchd_plist).with(
      user:   'root',
      group:  'wheel',
      mode:   '0644'
    )
    expect(chef_run).to render_file(launchd_plist).with_content(Regexp.new("^\\s+<string>/sbin/ifconfig</string>$"))
    expect(chef_run).to render_file(launchd_plist).with_content(Regexp.new("^\\s+<string>#{loopback_alias_ip}</string>$"))

    expect(chef_run.template(launchd_plist)).to notify('execute[load the com.runlevel1.lo0.alias plist into launchd]').to(:run)
  end

  context "when launchd plist is already loaded" do
    before(:all) do
      stub_command('launchctl list com.runlevel1.lo0.alias').and_return(true)
    end

    it "skips loading com.runlevel1.lo0.alias launchd plist file" do
      expect(chef_run.execute('load the com.runlevel1.lo0.alias plist into launchd')).to do_nothing
    end
  end
end
