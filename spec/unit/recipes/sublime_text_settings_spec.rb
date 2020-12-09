# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2016-2020 James Cuzella
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

describe 'lyraphase_workstation::sublime_text_settings' do

  let(:sublime_app_support_path) { '/Users/brubble/Library/Application Support/Sublime Text 3' }
  let(:shared_sublime_files_path) { '/Users/brubble/pCloud Drive/AppData/mac/sublime-text-3' }
  let(:shared_sublime_files) {
      [
        'Installed Packages',
        'Packages',
        'Local/License.sublime_license'
      ]
  }

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(platform: 'mac_os_x', version: '10.14') do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

      node.normal['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = sublime_app_support_path
      node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files'] = shared_sublime_files
      node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] = shared_sublime_files_path
    end.converge(described_recipe)
  }

  it 'installs symlinks to shared_files paths' do
    shared_sublime_files.each do |shared_file|
      expect(chef_run).to create_link("#{sublime_app_support_path}/#{shared_file}").with(
        user:   'brubble',
        mode: '0755',
        to: "#{shared_sublime_files_path}/#{shared_file}"
      )
    end
  end

  context 'when Sublime Text directories exist, and shared_files symlink targets exist' do

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = sublime_app_support_path
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files'] = shared_sublime_files
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] = shared_sublime_files_path
      end.converge(described_recipe)
    }

    before(:each) do
        allow(Dir).to receive(:exist?).and_call_original
        allow(File).to receive(:symlink?).and_call_original
        allow(File).to receive(:exist?).and_call_original
        shared_sublime_files.each do |symlink_path|
          allow(Dir).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:symlink?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(false)

          allow(Dir).to receive(:exist?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:exist?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:symlink?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(true)
        end
    end

    it 'should unlink them first' do
      shared_sublime_files.each do |symlink_path|
        expect(chef_run).to delete_directory("#{sublime_app_support_path}/#{symlink_path}")
      end
    end
  end

  context 'when Sublime Text directories DO NOT exist' do

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = sublime_app_support_path
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files'] = shared_sublime_files
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] = shared_sublime_files_path
      end.converge(described_recipe)
    }

    before(:each) do
      shared_sublime_files.each do |symlink_path|
        allow(Dir).to receive(:exist?).and_call_original
        allow(File).to receive(:symlink?).and_call_original
        allow(File).to receive(:exist?).and_call_original
        shared_sublime_files.each do |symlink_path|
          allow(Dir).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(false)
          allow(File).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(false)
          allow(File).to receive(:symlink?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(false)
        end
      end
    end

    it 'should NOT unlink them first' do
      shared_sublime_files.each do |symlink_path|
        expect(chef_run).to_not delete_directory("#{sublime_app_support_path}/#{symlink_path}")
      end
    end
  end


  context 'when Sublime Text directories exist, BUT shared_files symlink targets DO NOT exist' do

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = sublime_app_support_path
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files'] = shared_sublime_files
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] = shared_sublime_files_path
      end.converge(described_recipe)
    }

    before(:each) do
        allow(Dir).to receive(:exist?).and_call_original
        allow(File).to receive(:symlink?).and_call_original
        allow(File).to receive(:exist?).and_call_original
        shared_sublime_files.each do |symlink_path|
          allow(Dir).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:symlink?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(false)

          allow(Dir).to receive(:exist?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(false)
          allow(File).to receive(:exist?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(false)
          allow(File).to receive(:symlink?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(false)
        end
    end

    it 'should NOT unlink them first' do
      shared_sublime_files.each do |symlink_path|
        expect(chef_run).to_not delete_directory("#{sublime_app_support_path}/#{symlink_path}")
      end
    end
  end

  context 'when Sublime Text symlinks already exist, and shared_files symlink targets exist' do

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new(platform: 'mac_os_x', version: '10.11') do |node|
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'
        node.normal['lyraphase_workstation']['home'] = '/Users/brubble'

        node.normal['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = sublime_app_support_path
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files'] = shared_sublime_files
        node.normal['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] = shared_sublime_files_path
      end.converge(described_recipe)
    }

    before(:each) do
        allow(Dir).to receive(:exist?).and_call_original
        allow(File).to receive(:symlink?).and_call_original
        allow(File).to receive(:exist?).and_call_original
        shared_sublime_files.each do |symlink_path|
          allow(Dir).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:exist?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:symlink?).with("#{sublime_app_support_path}/#{symlink_path}").and_return(true)

          allow(Dir).to receive(:exist?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:exist?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(true)
          allow(File).to receive(:symlink?).with("#{shared_sublime_files_path}/#{symlink_path}").and_return(false)
        end
    end

    it 'should NOT delete already existing symlinks' do
      shared_sublime_files.each do |symlink_path|
        expect(chef_run).to_not delete_directory("#{sublime_app_support_path}/#{symlink_path}")
      end
    end
  end
end
