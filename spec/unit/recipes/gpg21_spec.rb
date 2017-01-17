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
  let(:gpgtools_plist_file_test) { '/Library/LaunchAgents/org.gpgtools.macgpg2.fix.ChefSpec.plist' }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.11.1') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      node.normal['lyraphase_workstation']['gpg21']['gpgtools_plist_file'] = gpgtools_plist_file_test
      stub_command("which git").and_return('/usr/local/bin/git')
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

  it "disables the gpgtools launchd plist file" do
    expect(chef_run).to update_plist_file(gpgtools_plist_file_test)
  end

  [
    {:description => 'when sshd_config does NOT already include StreamLocalBindUnlink',
     :test_fixture_filename => 'sshd_config',
     :post_edit_has_unwritten_changes => true},
    {:description => 'when sshd_config already includes StreamLocalBindUnlink',
     :test_fixture_filename => 'sshd_config_preexisting',
     :post_edit_has_unwritten_changes => false}
  ].each do |rspec_context|
    context rspec_context[:description] do
      # Avoid using let(:sshd_config_file) here, because the lazy evaluation causes a recursion loop (mock code runs before the lazy eval of sshd_config_file)
      # sshd_config_file = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')
      # Create a dummy class to include helper method: add_streamlocalbindunlink_to_sshd_config
      let(:dummy_class) { Class.new { include LyraPhase::Helpers } }

      before(:each) do
        # Set up mock LyraPhase::ConfigFile / FileEdit Object using our test fixture sample file
        test_fixture_filename = File.join(
          File.dirname(__FILE__), '..', '..', 'fixtures', rspec_context[:test_fixture_filename]
        )
        @sshd_config_file = nil # Ensure new one each example group
        # @sshd_config_file = Chef::Util::FileEdit.new(test_fixture_filename)
        ##@sshd_config_file = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')

        @sshd_config_file = LyraPhase::ConfigFile.new(test_fixture_filename)

        # allow_any_instance_of(Chef::Util::FileEdit).to receive(:new).with('/etc/ssh/sshd_config') { sshd_config_file }
        allow(LyraPhase::ConfigFile).to receive(:new).with('/etc/ssh/sshd_config') { @sshd_config_file }

        # Do not modify the file for real in ChefSpec tests!
        # Just return the success return value 'false'
        allow_any_instance_of(Chef::Util::FileEdit).to receive(:write_file) { false }
        # allow_any_instance_of(LyraPhase::ConfigFile).to receive(:write_file) { false }
        # allow(sshd_config_file).to receive(:write_file) { false }
        # RSpec 2 syntax does not work anymore
        # Chef::Util::FileEdit.stub(:new).with('/etc/ssh/sshd_config').and_return(sshd_config_file)
      end

      it 'ChefSpec tests should mock the /etc/ssh/sshd_config Chef::Util::FileEdit Object' do
        expect(chef_run).to receive(:converge)
        chef_run.converge(described_recipe)
        expect(@sshd_config_file).to receive(:insert_line_if_no_match).twice
        expect(@sshd_config_file).to receive(:write_file)
        # Sanity check that RSpec Mocks is working
        # Check Mock object is eq & identical to the one that the recipe ruby_block & ChefSpec tests will always get
        expect(LyraPhase::ConfigFile.new('/etc/ssh/sshd_config')).to eq(@sshd_config_file)
        expect(LyraPhase::ConfigFile.new('/etc/ssh/sshd_config')).to be @sshd_config_file
        expect(@sshd_config_file).to be_an_instance_of(LyraPhase::ConfigFile)

        # See git history for RSpec 2 code reference

        # Before any calls to insert_line_if_no_match
        expect(@sshd_config_file.file_edited?).to be false
        expect(@sshd_config_file.unwritten_changes?).to be false

        # ChefSpec does not run the ruby_block, so we must simulate
        # Simulate what the recipe does on our Mock Wrapper Object
        dummy_class.new.add_streamlocalbindunlink_to_sshd_config

        # This is a simulation, so write_file should be stubbed & never really edit file
        expect(@sshd_config_file.file_edited?).to be false
      end

      it 'adds StreamLocalBindUnlink to sshd config' do
        # chef_run.converge(described_recipe)
        # task_ruby_block = chef_run.find_resources(:ruby_block).find { |r| r.name == 'add StreamLocalBindUnlink to sshd config' }
        task_ruby_block = chef_run.ruby_block('add StreamLocalBindUnlink to sshd config')
        expect(task_ruby_block.instance_variable_get(:@action)).to eq [:run]
        expect(chef_run).to run_ruby_block('add StreamLocalBindUnlink to sshd config')

        # Inspect inside the object's file lines
        file_lines = @sshd_config_file.instance_variable_get(:@editor).instance_variable_get(:@lines)

        # ChefSpec does not run the ruby_block, so we must simulate
        # Simulate what the recipe does on our Mock Wrapper Object
        dummy_class.new.add_streamlocalbindunlink_to_sshd_config

        # It should add 1 line matching each pattern to be Idempotent & avoid appending more each run
        expect(file_lines.grep(/.*Remove stale forwarding sockets.*/).length).to eq 1
        expect(file_lines.grep(/^\s*StreamLocalBindUnlink.*/).length).to eq 1
        # Check the exact setting is enabled
        expect(file_lines.grep(/^\s*StreamLocalBindUnlink.*/)[0]).to match 'StreamLocalBindUnlink yes'

        expect(@sshd_config_file.unwritten_changes?).to be rspec_context[:post_edit_has_unwritten_changes]
      end
    end
  end
end

