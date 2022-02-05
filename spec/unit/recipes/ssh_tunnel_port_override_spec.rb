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

describe 'lyraphase_workstation::ssh_tunnel_port_override' do

  let(:launchd_plist) { "/Library/LaunchDaemons/com.lyraphase.ssh-tunnel-port-override.plist" }
  let(:ssh_tunnel_port_override_log) { "/var/log/ssh-tunnel-port-override.log" }
  let(:ssh_tunnel_port_override_port) { '8081' }
  let(:ssh_tunnel_port_override_script) { '/Users/brubble/bin/ssh-tunnel-port-override.sh' }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.11') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      stub_command("which git").and_return('/usr/local/bin/git')

      stub_command('launchctl list com.lyraphase.ssh-tunnel-port-override').and_return(true)
      stub_command("sudo launchctl list com.lyraphase.ssh-tunnel-port-override").and_return(true)
    end.converge(described_recipe)
  }

  it 'creates log file for com.lyraphase.ssh-tunnel-port-override service' do
    expect(chef_run).to create_file(ssh_tunnel_port_override_log).with(
      user:   'root',
      group:  'wheel',
      mode:   '0664'
    )
  end

  it 'installs script for com.lyraphase.ssh-tunnel-port-override' do
    expect(chef_run).to create_template(ssh_tunnel_port_override_script).with(
      user:   'brubble',
      group:  'wheel',
      mode:   '0755'
    )
    expect(chef_run).to render_file(ssh_tunnel_port_override_script).with_content(Regexp.new("^.*grep -iE ':#{ssh_tunnel_port_override_port}.*LISTEN'"))
    expect(chef_run).to render_file(ssh_tunnel_port_override_script).with_content(Regexp.new("^.*\\s+port\\s+#{ssh_tunnel_port_override_port}"))
  end

  it 'installs launchd plist for com.lyraphase.ssh-tunnel-port-override' do
    expect(chef_run).to create_template(launchd_plist).with(
      user:   'root',
      group:  'wheel',
      mode:   '0644'
    )
    expect(chef_run).to render_file(launchd_plist).with_content(Regexp.new("^\\s+<string>#{ssh_tunnel_port_override_script}</string>$"))

    expect(chef_run.template(launchd_plist)).to notify('execute[load the com.lyraphase.ssh-tunnel-port-override plist into launchd]').to(:run)
  end

  context "when launchd plist is already loaded" do
    before(:all) do
      stub_command('launchctl list com.lyraphase.ssh-tunnel-port-override').and_return(true)
    end

    it "skips loading com.lyraphase.ssh-tunnel-port-override launchd plist file" do
      expect(chef_run.execute('load the com.lyraphase.ssh-tunnel-port-override plist into launchd')).to do_nothing
    end
  end
end

