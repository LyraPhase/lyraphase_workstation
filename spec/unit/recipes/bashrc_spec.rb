# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook Name:: lyraphase_workstation
# Recipe:: bashrc
# Site:: https://www.gnu.org/software/bash/
#
# Copyright (C) © 🄯 2016-2022 James Cuzella
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

shared_examples 'bash_logout' do
  let(:bash_logout_path) { '/Users/brubble/.bash_logout' }
  it 'installs custom .bash_logout into user homedir' do
    expect(chef_run).to create_template(bash_logout_path).with(
      user:   'brubble',
      mode: '0644'
    )
  end
end

shared_examples 'it does not raise error' do
  it 'does not raise error' do
    expect { chef_run }.to_not raise_error
  end
end

shared_examples 'default .bashrc' do
  let(:bashrc_path) { '/Users/brubble/.bashrc' }
  it 'installs custom .bashrc into user homedir with expected settings' do
    expect(chef_run).to create_template(bashrc_path).with(
      user:   'brubble',
      mode: '0644'
    )

    [ "export DEBFULLNAME='#{chef_run.node['lyraphase_workstation']['bashrc']['user_fullname']}'",
      "export DEBEMAIL='#{chef_run.node['lyraphase_workstation']['bashrc']['user_email']}'",
      "export DEBSIGN_KEYID='#{chef_run.node['lyraphase_workstation']['bashrc']['user_gpg_keyid']}'"
    ].each do |expected_regex|
      expect(chef_run).to render_file(bashrc_path).with_content(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
    end

    # Default is no / empty attributes:
    #  - homebrew_github_api_token
    #  - homebrew_no_cleanup_formulae
    [ "export HOMEBREW_GITHUB_API_TOKEN='#{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_github_api_token']}'",
      "export HOMEBREW_GITHUB_API_TOKEN='.*?' # #{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_github_api_token_comment']}",
      "export HOMEBREW_NO_CLEANUP_FORMULAE=.*"
    ].each do |expected_regex|
      # Note: Negated with_content requires passing a Proc / Block!
      # Reference: https://github.com/chefspec/chefspec/issues/865
      expect(chef_run).to(render_file(bashrc_path).with_content do |content|
        expect(content).not_to match(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
      end)
    end
  end
end

describe_recipe 'lyraphase_workstation::bashrc' do
  context 'when given all bashrc attributes' do
    # Override ChefSpec attributes from spec_shared_contexts
    let(:chefspec_options) {
      require 'securerandom'
      require 'date'
      {
        default_attributes: {},
        normal_attributes: { 'lyraphase_workstation': {
                              'bashrc': {
                                'homebrew_github_api_token': "gh_#{SecureRandom.hex(20)}",
                                'homebrew_github_api_token_comment': "rotgut butanol - #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S %z')} - lyra.37om.com - public_repo RO",
                                'user_fullname': 'Barney Rubble',
                                'user_email': 'barney.rubble@lyraphase.com',
                                'user_gpg_keyid': "0x#{SecureRandom.hex(8)}",
                                'homebrew_no_cleanup_formulae': ['argocd','eksctl','kustomize','rancher-cli','kubernetes-cli']
                              }
                            }
                          },
        automatic_attributes: {}
      }
    }

    let(:bashrc_path) { '/Users/brubble/.bashrc' }

    # Normal stub works for describe_recipe shared context b/c it has no before blocks defined
    before(:each) do
      stub_data_bag_item("lyraphase_workstation", "bashrc").and_return(nil)
    end

    it 'installs custom .bashrc into user homedir with given settings' do
      expect(chef_run).to create_template(bashrc_path).with(
        user:   'brubble',
        mode: '0644'
      )

      [ "export HOMEBREW_GITHUB_API_TOKEN='#{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_github_api_token']}'",
        "export HOMEBREW_GITHUB_API_TOKEN='.*?' # #{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_github_api_token_comment']}",
        "export DEBFULLNAME='#{chef_run.node['lyraphase_workstation']['bashrc']['user_fullname']}'",
        "export DEBEMAIL='#{chef_run.node['lyraphase_workstation']['bashrc']['user_email']}'",
        "export DEBSIGN_KEYID='#{chef_run.node['lyraphase_workstation']['bashrc']['user_gpg_keyid']}'",
        "export HOMEBREW_NO_CLEANUP_FORMULAE=#{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_no_cleanup_formulae'].join(',')}"
      ].each do |expected_regex|
        expect(chef_run).to render_file(bashrc_path).with_content(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
      end
    end

    include_examples 'bash_logout'
  end

  context 'when given no (default) bashrc attributes' do
    # Use ChefSpec attributes from spec_shared_contexts

    before(:each) do
      stub_data_bag_item("lyraphase_workstation", "bashrc").and_return(nil)
    end

    include_examples 'default .bashrc'
    include_examples 'bash_logout'
  end
end

describe_recipe_with_expected_logs 'lyraphase_workstation::bashrc' do
  # Use ChefSpec attributes from spec_shared_contexts
  # Override ChefSpec attributes from spec_shared_contexts
  let(:chefspec_options) {
    require 'securerandom'
    require 'date'
    {
      default_attributes: {},
      normal_attributes: { 'lyraphase_workstation': {
                            'bashrc': {
                              'homebrew_github_api_token': nil,
                              'homebrew_github_api_token_comment': nil
                            }
                          }
                        },
      automatic_attributes: {}
    }
  }

  context 'when given a valid data_bag_item' do
    # Override method to stub at the shared_context level
    # Needed here b/c describe_recipe_with_expected_logs defines before(:each) already,
    # and we need to hook into it at that top-level context
    def before_each_shared_example
      valid_data_bag_item = { "id": "bashrc", "fauxhai.local": { "homebrew_github_api_token": "gh_f00dcafefauxhai", "homebrew_github_api_token_comment": "This is a valid data bag item" } }
      stub_data_bag_item("lyraphase_workstation", "bashrc").and_return(valid_data_bag_item)
    end

    # Expect Chef::Log.info message
    let(:chef_log_info_msgs) {
      ["Loading Homebrew GitHub API token for Node Name: #{node['name']}"]
    }
    let(:bashrc_path) { '/Users/brubble/.bashrc' }

    it_outputs 'Chef INFO Logs'

    it 'installs custom .bashrc into user homedir with given settings' do
      expect(chef_run).to create_template(bashrc_path).with(
        user: 'brubble',
        mode: '0644'
      )

      [ "export HOMEBREW_GITHUB_API_TOKEN='gh_f00dcafefauxhai'",
        "export HOMEBREW_GITHUB_API_TOKEN='.*?' # This is a valid data bag item"
      ].each do |expected_regex|
        expect(chef_run).to render_file(bashrc_path).with_content(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
      end
    end

    include_examples 'it does not raise error'
    include_examples 'bash_logout'
  end

  context 'when given invalid data_bag_item Schema' do
    def before_each_shared_example
      invalid_data_bag_item = { id: 'bashrc', comment: 'wrong schema',
        homebrew_github_api_token: "gh_#{SecureRandom.hex(20)}",
        homebrew_github_api_token_comment: 'This should be under node name hash key'
      }
      stub_data_bag_item('lyraphase_workstation', 'bashrc').and_return(invalid_data_bag_item)
    end
    # Expect Chef::Log.warn messages
    let(:chef_log_warn_msgs) {
      [
        "Could not find Homebrew GitHub API token attribute homebrew_github_api_token in data bag item lyraphase_workstation:bashrc for Node Name: #{node['name']}",
        "Could not find Homebrew GitHub API token attribute homebrew_github_api_token_comment in data bag item lyraphase_workstation:bashrc for Node Name: #{node['name']}",
        "Expected Data Bag Item Schema: {\"id\": \"bashrc\", \"#{node['name']}\": {\"homebrew_github_api_token\": \"gh_f00dcafevagrant\", \"homebrew_github_api_token_comment\": \"some optional comment\"}}"
      ]
    }

    it_outputs 'Chef WARN Logs'
    include_examples 'it does not raise error'
    include_examples 'default .bashrc'
  end
end
