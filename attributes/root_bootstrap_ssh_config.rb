# -*- coding: utf-8 -*-
# frozen_string_literal: true

default['lyraphase_workstation']['root_bootstrap_ssh_config'] = {}
default['lyraphase_workstation']['root_bootstrap_ssh_config']['identity_file'] = 'identity.lyra'
# Use Yubikey through main sprout user's SSH_AUTH_SOCK
# NOTE: May depend on gpg-suite Homebrew cask depending on macOS version
default['lyraphase_workstation']['root_bootstrap_ssh_config']['ssh_auth_sock'] = File.join(node['lyraphase_workstation']['home'], '.gnupg', 'S.gpg-agent.ssh')
