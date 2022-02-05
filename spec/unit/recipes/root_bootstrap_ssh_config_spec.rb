# -*- coding: utf-8 -*-
# frozen_string_literal: true

#
# Cookbook:: lyraphase_workstation
# Spec:: root_bootstrap_ssh_config
#
# Copyright:: (C) © 🄯  2013-2021 James Cuzella
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

describe_recipe 'lyraphase_workstation::root_bootstrap_ssh_config' do
  context 'when root .ssh/* files do not exist' do
    let(:root_ssh) { '/var/root/.ssh' }
    let(:root_ssh_config) { '/var/root/.ssh/config' }
    let(:root_ssh_known_hosts) { '/var/root/.ssh/known_hosts' }
    let(:root_sh_profile) { '/var/root/.profile' }
    # Override ChefSpec attributes from spec_shared_contexts
    let(:chefspec_options) do
      # rubocop:disable Style/TrailingCommaInHashLiteral
      {
        normal_attributes: {
          'lyraphase_workstation': {
            'root_bootstrap_ssh_config': {
              'identity_file': 'identity.brubble',
              'ssh_auth_sock': '/Users/brubble/.gnupg/S.gpg-agent.ssh'
            }
          }
        }
      }
      # rubocop:enable Style/TrailingCommaInHashLiteral
    end

    before :each do
      stub_command('grep -q github.com known_hosts').and_return(false)
      allow(File).to receive(:exists?).and_call_original
      allow(File).to receive(:exists?).with(anything).and_call_original
      allow(File).to receive(:exists?).with('/var/root/.ssh').and_return(false)
      allow(File).to receive(:exists?).with('/var/root/.ssh/config').and_return(false)
      allow(File).to receive(:exists?).with('/var/root/.ssh/known_hosts').and_return(false)
      expect(File).not_to be_exists('/var/root/.ssh')
      expect(File).not_to be_exists('/var/root/.ssh/config')
      expect(File).not_to be_exists('/var/root/.ssh/known_hosts')
      expect(File).not_to be_exists('/var/root/.profile')
    end

    it 'creates directory /var/root/.ssh' do
      expect(chef_run).to create_directory(root_ssh).with(
        owner: 'root',
        group: 'wheel',
        mode: '0700'
      )
    end

    it 'creates known_hosts file if missing' do
      expect(chef_run).to create_file_if_missing(root_ssh_known_hosts).with(
        owner: 'root',
        group: 'wheel',
        mode: '0644'
      )
    end

    it 'adds github rsa keys to known_hosts' do
      expect(chef_run).to run_execute('add github to known_hosts').with(user: 'root')
    end

    it 'creates a template for /var/root/.ssh/config' do
      expect(chef_run).to create_template(root_ssh_config).with(
        user: 'root',
        group: 'wheel',
        mode: '0600'
      )
    end

    it 'creates minimal root user github.com ssh config' do
      # rubocop:disable Style/RegexpLiteral
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+IdentityFile\s+\/Users\/brubble\/.ssh\/identity.brubble$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^Host github\.com$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+User\s+git$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+Hostname\s+github\.com$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+PreferredAuthentications\s+publickey$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+StrictHostKeyChecking\s+no$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+UserKnownHostsFile\s+\/dev\/null$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+UpdateHostKeys\s+yes$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+UseKeychain\s+yes$/)
      expect(chef_run).to render_file(root_ssh_config).with_content(/^\s+AddKeysToAgent\s+yes$/)
      # rubocop:enable Style/RegexpLiteral
    end

    it 'creates a template for /var/root/.profile' do
      expect(chef_run).to create_template(root_sh_profile).with(
        user: 'root',
        group: 'wheel',
        mode: '0644'
      )
      # rubocop:disable Style/RegexpLiteral
      expect(chef_run).to render_file(root_sh_profile).with_content(/^export SSH_AUTH_SOCK=\/Users\/brubble\/.gnupg\/S.gpg-agent.ssh$/)
      # rubocop:enable Style/RegexpLiteral
    end
  end

  context 'when root .ssh/* files already exist and github.com already in known_hosts ...' do
    let(:root_ssh) { '/var/root/.ssh' }
    let(:root_ssh_config) { '/var/root/.ssh/config' }
    let(:root_ssh_known_hosts) { '/var/root/.ssh/known_hosts' }
    # Override ChefSpec attributes from spec_shared_contexts
    let(:chefspec_options) do
      { normal_attributes: { 'lyraphase_workstation': { 'root_bootstrap_ssh_config': { 'identity_file': 'identity.brubble' } } } }
    end

    before :each do
      stub_command('grep -q github.com known_hosts').and_return(true)
      allow(File).to receive(:exists?).and_call_original
      allow(File).to receive(:exists?).with(anything).and_call_original
      allow(File).to receive(:exists?).with('/var/root/.ssh').and_return(true)
      allow(File).to receive(:exists?).with('/var/root/.ssh/config').and_return(true)
      allow(File).to receive(:exists?).with('/var/root/.ssh/known_hosts').and_return(true)
      expect(File).to be_exists('/var/root/.ssh')
      expect(File).to be_exists('/var/root/.ssh/config')
      expect(File).to be_exists('/var/root/.ssh/known_hosts')
    end

    it 'creates known_hosts file if missing' do
      expect(chef_run).to create_file_if_missing(root_ssh_known_hosts).with(
        owner: 'root',
        group: 'wheel',
        mode: '0644'
      )
    end

    it 'skips adding github rsa keys to known_hosts' do
      expect(chef_run).not_to run_execute('add github to known_hosts').with(user: 'root')
    end
  end
end
