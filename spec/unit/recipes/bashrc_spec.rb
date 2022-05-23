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

describe_recipe 'lyraphase_workstation::bashrc' do
  context 'when given all bashrc attributes' do
    # Override ChefSpec attributes from spec_shared_contexts
    let(:chefspec_options) {
      require 'securerandom'
      {
        default_attributes: {},
        normal_attributes: { 'lyraphase_workstation': {
                              'bashrc': {
                                'homebrew_github_api_token': "gh_#{SecureRandom.hex(20)}",
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
    let(:bash_logout_path) { '/Users/brubble/.bash_logout' }

    it 'installs custom .bashrc into user homedir with given settings' do
      expect(chef_run).to create_template(bashrc_path).with(
        user:   'brubble',
        mode: '0644'
      )

      [ "export HOMEBREW_GITHUB_API_TOKEN='#{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_github_api_token']}'",
        "export DEBFULLNAME='#{chef_run.node['lyraphase_workstation']['bashrc']['user_fullname']}'",
        "export DEBEMAIL='#{chef_run.node['lyraphase_workstation']['bashrc']['user_email']}'",
        "export DEBSIGN_KEYID='#{chef_run.node['lyraphase_workstation']['bashrc']['user_gpg_keyid']}'",
        "export HOMEBREW_NO_CLEANUP_FORMULAE=#{chef_run.node['lyraphase_workstation']['bashrc']['homebrew_no_cleanup_formulae'].join(',')}"
      ].each do |expected_regex|
        expect(chef_run).to render_file(bashrc_path).with_content(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
      end
    end

    it 'installs custom .bash_logout into user homedir' do
      expect(chef_run).to create_template(bash_logout_path).with(
        user:   'brubble',
        mode: '0644'
      )
    end
  end

  context 'when given no (default) bashrc attributes' do
    # Use ChefSpec attributes from spec_shared_contexts
    let(:bashrc_path) { '/Users/brubble/.bashrc' }
    let(:bash_logout_path) { '/Users/brubble/.bash_logout' }

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
        "export HOMEBREW_NO_CLEANUP_FORMULAE=.*"
      ].each do |expected_regex|
        # Note: Negated with_content requires passing a Proc / Block!
        # Reference: https://github.com/chefspec/chefspec/issues/865
        expect(chef_run).to(render_file(bashrc_path).with_content do |content|
          expect(content).not_to match(Regexp.new("^\s*#{expected_regex}\s*(#.*)?$"))
        end)
      end
    end

    it 'installs custom .bash_logout into user homedir' do
      expect(chef_run).to create_template(bash_logout_path).with(
        user:   'brubble',
        mode: '0644'
      )
    end
  end
end
