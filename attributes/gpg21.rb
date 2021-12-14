# -*- coding: utf-8 -*-
# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
default['lyraphase_workstation']['gpg21'] = {}
default['lyraphase_workstation']['gpg21']['gpgtools_plist_file'] = '/Library/LaunchAgents/org.gpgtools.macgpg2.fix.plist'
default['lyraphase_workstation']['gpg21']['binary_paths'] =
  [
    '/usr/local/bin/addgnupghome',
    '/usr/local/bin/applygnupgdefaults',
    '/usr/local/bin/dirmngr',
    '/usr/local/bin/dirmngr-client',
    '/usr/local/bin/gpg-agent',
    '/usr/local/bin/gpg-connect-agent',
    '/usr/local/bin/gpg2',
    '/usr/local/bin/gpgconf',
    '/usr/local/bin/gpgparsemail',
    '/usr/local/bin/gpgscm',
    '/usr/local/bin/gpgsm',
    '/usr/local/bin/gpgtar',
    '/usr/local/bin/gpgv2',
    '/usr/local/bin/kbxutil',
    '/usr/local/bin/symcryptrun',
    '/usr/local/bin/watchgnupg'
  ]
# rubocop:enable Metrics/LineLength
