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


describe 'lyraphase_workstation::ableton_live_options' do

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

