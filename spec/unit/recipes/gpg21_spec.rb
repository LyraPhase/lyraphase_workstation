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

content = <<EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <false/>
  <key>Label</key>
  <string>org.gpgtools.macgpg2.fix</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/MacGPG2/libexec/fixGpgHome</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>

EOPLIST

updated_content = <<EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <false/>
  <key>Label</key>
  <string>org.gpgtools.macgpg2.fix</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/MacGPG2/libexec/fixGpgHome</string>
  </array>
  <key>RunAtLoad</key>
  <false/>
</dict>
</plist>

EOPLIST

test_file = Pathname.new(Dir.tmpdir) + "plist_file_push_spec.plist"

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

      node.normal['lyraphase_workstation']['gpg21']['gpgtools_plist_file'] = test_file
    end.converge(described_recipe)
  }

  before(:all) do
    test_file.open("wb") { |f| f.write(content) }

    # ChefSpec::ServerRunner.new(step_into: ["plist_file"]) do |node|
    #   node.set['lyraphase_workstation']['airfoil']['plist_file'] = test_file
    # end.converge(described_recipe)

  end

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

  let(:sshd_config_file) { instance_double('Chef::Util::FileEdit') }
  let(:dummy_class) { Chef::Util::FileEdit }
  before do
    allow_any_instance_of(dummy_class).to receive(:new).with('/etc/ssh/sshd_config') { sshd_config_file }
    # allow(dummy_class).to receive(:new).with('/etc/ssh/sshd_config') { sshd_config_file }
    allow(sshd_config_file).to receive(:insert_line_if_no_match).with("/^# Remove stale forwarding sockets (https://wiki.gnupg.org/AgentForwarding)/", "# Remove stale forwarding sockets (https://wiki.gnupg.org/AgentForwarding)")
    allow(sshd_config_file).to receive(:insert_line_if_no_match).with("/^StreamLocalBindUnlink.*/", "StreamLocalBindUnlink yes")
    # allow(sshd_config_file).to receive(:write_file) {}
    # RSpec 2 syntax
    # Chef::Util::FileEdit.stub(:new).with('/etc/ssh/sshd_config').and_return(sshd_config_file)
  end

  it "disables the gpgtools launchd plist file" do
    # File.open('/tmp/chefspec.plist', 'w') do |f|
    #   f.write(test_file.open("rb") { |f| f.read })
    # end
    # expect(test_file.open("rb") { |f| f.read }).to eq(updated_content)
    expect(chef_run).to update_plist_file(test_file)
  end

  it 'adds StreamLocalBindUnlink to sshd config' do
    expect(dummy_class.new('/etc/ssh/sshd_config')).to eq(sshd_config_file)
    # Chef::Util::FileEdit.should_receive(:new).with('/etc/ssh/sshd_config').and_return(sshd_config_file)
    # sshd_config_file.should_receive(:insert_line_if_no_match).with('example.com', '1.1.1.1 2.2.2.2')
    # sshd_config_file.should_receive(:write_file)
    expect(sshd_config_file).to be_an_instance_of?(Chef::Util::FileEdit)
  end

end

