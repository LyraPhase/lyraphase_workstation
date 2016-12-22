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

# TODO: D.R.Y. the rest of this up somehow
describe 'lyraphase_workstation::ableton_live_options' do
  nil_empty_string_cases = [
    {:case_name => 'nil', :ableton_live_managed_versions => nil},
    {:case_name => 'empty string', :ableton_live_managed_versions => ''}
  ]

  nil_empty_string_cases.each do |example_case|
    context "when given #{example_case[:case_name]} for managed_versions: #{example_case[:ableton_live_managed_versions]}" do
      let(:ableton_preferences_path) { "/Users/brubble/Library/Preferences/Ableton" }
      expected_options = ["EnableMapToSiblings", "AutoAdjustMacroMappingRange", "_PluginAutoPopulateThreshold=-1"]
      ableton_live_managed_versions = example_case[:ableton_live_managed_versions]

      # In this case, the recipe should only install the latest version
      all_versions_to_stub = ["9.1.9", "9.5", "9.5.1b2", "9.5.1b6", "9.6b1", "9.6b2", "9.6.1b5", "9.6.1b6", "9.6.1b7", "9.6.2b1", "9.6.2b2", "9.7", "9.7.1"]
      ableton_all_preference_paths = all_versions_to_stub.map{ |v| "/Users/brubble/Library/Preferences/Ableton/Live #{v}" }

      ableton_live_latest_expected_version = '9.7.1'
      ableton_live_version = ableton_live_latest_expected_version

      before(:each) do
        allow(Dir).to receive(:glob).and_call_original
        allow(Dir).to receive(:glob).with("#{ableton_preferences_path}/*") { ableton_all_preference_paths }
      end

      let(:chef_run) {
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new do |node|
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.set['lyraphase_workstation']['user'] = 'brubble'
          node.set['lyraphase_workstation']['home'] = '/Users/brubble'
          node.set['lyraphase_workstation']['ableton_live']['options'] = expected_options
          node.set['lyraphase_workstation']['ableton_live']['managed_versions'] = ableton_live_managed_versions
        end.converge(described_recipe)
      }


      it "creates Ableton Preferences directory for latest detected version: #{ableton_live_version}" do
        expected_directory = "#{ableton_preferences_path}/Live #{ableton_live_version}"
        expect(chef_run).to create_directory(expected_directory)
      end

      it 'installs Ableton Options.txt for latest detected version: #{ableton_live_version}' do
        options_txt_filename = "#{ableton_preferences_path}/Live #{ableton_live_version}/Options.txt"
        expect(chef_run).to create_template(options_txt_filename).with(
          user:   'brubble',
          mode: '0644'
        )
        expected_options.each do |expected_option|
          expect(chef_run).to render_file(options_txt_filename).with_content(Regexp.new("^-#{expected_option}$"))
        end
      end
    end
  end

  context "when given Array of managed_versions: ['9.7.1', '9.1.9', '9.5.1b2', '9.5.1b6']" do
    let(:ableton_preferences_path) { "/Users/brubble/Library/Preferences/Ableton" }
    expected_options = ["EnableMapToSiblings", "AutoAdjustMacroMappingRange", "_PluginAutoPopulateThreshold=-1"]
    ableton_live_managed_versions = ['9.7.1', '9.1.9', '9.5.1b2', '9.5.1b6']

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['lyraphase_workstation']['user'] = 'brubble'
        node.set['lyraphase_workstation']['home'] = '/Users/brubble'
        node.set['lyraphase_workstation']['ableton_live']['options'] = expected_options
        node.set['lyraphase_workstation']['ableton_live']['managed_versions'] = ableton_live_managed_versions
      end.converge(described_recipe)
    }

    ableton_live_managed_versions.each do |ableton_live_version|
      it 'creates Ableton Preferences directory' do
        expected_directory = "#{ableton_preferences_path}/Live #{ableton_live_version}"
        expect(chef_run).to create_directory(expected_directory)
      end

      it 'installs Ableton Options.txt' do
        options_txt_filename = "#{ableton_preferences_path}/Live #{ableton_live_version}/Options.txt"
        expect(chef_run).to create_template(options_txt_filename).with(
          user:   'brubble',
          mode: '0644'
        )
        expected_options.each do |expected_option|
          expect(chef_run).to render_file(options_txt_filename).with_content(Regexp.new("^-#{expected_option}$"))
        end
      end
    end
  end

  context "when given String for managed_versions: '9.5.1b2'" do
    let(:ableton_preferences_path) { "/Users/brubble/Library/Preferences/Ableton" }
    expected_options = ["EnableMapToSiblings", "AutoAdjustMacroMappingRange", "_PluginAutoPopulateThreshold=-1"]
    ableton_live_managed_versions = '9.5.1b2'
    ableton_live_version = ableton_live_managed_versions

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['lyraphase_workstation']['user'] = 'brubble'
        node.set['lyraphase_workstation']['home'] = '/Users/brubble'
        node.set['lyraphase_workstation']['ableton_live']['options'] = expected_options
        node.set['lyraphase_workstation']['ableton_live']['managed_versions'] = ableton_live_managed_versions
      end.converge(described_recipe)
    }


    it 'creates Ableton Preferences directory' do
      expected_directory = "#{ableton_preferences_path}/Live #{ableton_live_version}"
      expect(chef_run).to create_directory(expected_directory)
    end

    it 'installs Ableton Options.txt' do
      options_txt_filename = "#{ableton_preferences_path}/Live #{ableton_live_version}/Options.txt"
      expect(chef_run).to create_template(options_txt_filename).with(
        user:   'brubble',
        mode: '0644'
      )
      expected_options.each do |expected_option|
        expect(chef_run).to render_file(options_txt_filename).with_content(Regexp.new("^-#{expected_option}$"))
      end
    end
  end

  context 'when given managed_versions: "all"' do
    let(:ableton_preferences_path) { "/Users/brubble/Library/Preferences/Ableton" }
    expected_options = ["EnableMapToSiblings", "AutoAdjustMacroMappingRange", "_PluginAutoPopulateThreshold=-1"]
    ableton_live_managed_versions = ["9.1.9", "9.5", "9.5.1b2", "9.5.1b6", "9.6b1", "9.6b2", "9.6.1b5", "9.6.1b6", "9.6.1b7", "9.6.2b1", "9.6.2b2", "9.7", "9.7.1"]
    ableton_all_preference_paths = ableton_live_managed_versions.map{ |v| "/Users/brubble/Library/Preferences/Ableton/Live #{v}" }

    before(:each) do
      allow(Dir).to receive(:glob).and_call_original
      allow(Dir).to receive(:glob).with("#{ableton_preferences_path}/*") { ableton_all_preference_paths }
    end

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['lyraphase_workstation']['user'] = 'brubble'
        node.set['lyraphase_workstation']['home'] = '/Users/brubble'
        node.set['current_user'] = 'brubble'

        node.set['lyraphase_workstation']['ableton_live']['options'] = expected_options
        node.set['lyraphase_workstation']['ableton_live']['managed_versions'] = 'all'
      end.converge(described_recipe)
    }

    ableton_live_managed_versions.each do |ableton_live_version|
      it 'creates Ableton Preferences directory' do
        expected_directory = "#{ableton_preferences_path}/Live #{ableton_live_version}"
        expect(chef_run).to create_directory(expected_directory)
      end

      it 'installs Ableton Options.txt' do
        options_txt_filename = "#{ableton_preferences_path}/Live #{ableton_live_version}/Options.txt"
        expect(chef_run).to create_template(options_txt_filename).with(
          user:   'brubble',
          mode: '0644'
        )
        expected_options.each do |expected_option|
          expect(chef_run).to render_file(options_txt_filename).with_content(Regexp.new("^-#{expected_option}$"))
        end
      end
    end
  end

  context "when given invalid options and String for managed_versions: '9.5.1b2'" do
    let(:ableton_preferences_path) { "/Users/brubble/Library/Preferences/Ableton" }
    expected_options = ["EnableMapToSiblings", "AutoAdjustMacroMappingRange", "_PluginAutoPopulateThreshold=-1"]
    given_options = ["ReWireRockwellRetroEncabulator", "FizzBuzzInvalid", "EnableMapToSiblings", "AutoAdjustMacroMappingRange", "_PluginAutoPopulateThreshold=-1"]
    ableton_live_managed_versions = '9.5.1b2'
    ableton_live_version = ableton_live_managed_versions

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.set['lyraphase_workstation']['user'] = 'brubble'
        node.set['lyraphase_workstation']['home'] = '/Users/brubble'
        node.set['lyraphase_workstation']['ableton_live']['options'] = given_options
        node.set['lyraphase_workstation']['ableton_live']['managed_versions'] = ableton_live_managed_versions
      end.converge(described_recipe)
    }


    it 'creates Ableton Preferences directory' do
      expected_directory = "#{ableton_preferences_path}/Live #{ableton_live_version}"
      expect(chef_run).to create_directory(expected_directory)
    end

    it 'installs Ableton Options.txt' do
      options_txt_filename = "#{ableton_preferences_path}/Live #{ableton_live_version}/Options.txt"
      expect(chef_run).to create_template(options_txt_filename).with(
        user:   'brubble',
        mode: '0644'
      )
      expected_options.each do |expected_option|
        expect(chef_run).to render_file(options_txt_filename).with_content(Regexp.new("^-#{expected_option}$"))
      end
      (given_options - expected_options).each do |invalid_option|
        expect(chef_run).not_to render_file(options_txt_filename).with_content(Regexp.new("^-#{invalid_option}$"))
      end
    end
  end
end

