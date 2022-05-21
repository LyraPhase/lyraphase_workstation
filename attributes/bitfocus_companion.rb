# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'chef/exceptions'

# rubocop:disable Metrics/LineLength
case node['kernel']['machine']
when 'arm64'
  Chef::Log.info("lyraphase_workstation::bitfocus_companion: Detected arm64! Using Apple Silicon compatible installer")
  default['lyraphase_workstation']['bitfocus_companion']['dmg']['source']      = 'http://www.lyraphase.com/doc/installers/mac/bitfocus-companion-2.2.0-ccea40c7-mac-arm64.dmg'
  default['lyraphase_workstation']['bitfocus_companion']['dmg']['checksum']    = 'ca7d293f0ada8574465f02af08110655a2b61ca3351cd6d4a0e83a34e6ea053d'
  default['lyraphase_workstation']['bitfocus_companion']['dmg']['dmg_name']    = 'bitfocus-companion-2.2.0-ccea40c7-mac-arm64'
when 'x86_64'
  Chef::Log.info("lyraphase_workstation::bitfocus_companion: Detected x86_64! Using Intel Mac compatible installer")
  default['lyraphase_workstation']['bitfocus_companion']['dmg']['source']      = 'http://www.lyraphase.com/doc/installers/mac/bitfocus-companion-2.2.0-ccea40c7-mac-x64.dmg'
  default['lyraphase_workstation']['bitfocus_companion']['dmg']['checksum']    = 'e1b7015eb4e14ad1cc7b9068fff19f53a137512fc6570e849369d15921762020'
  default['lyraphase_workstation']['bitfocus_companion']['dmg']['dmg_name']    = 'bitfocus-companion-2.2.0-ccea40c7-mac-x64'
else
  Chef::Log.fatal("lyraphase_workstation::bitfocus_companion: Could not detect Hardware Architecture via node['kernel']['machine'] ! Could not find a compatible installer!")
  raise Chef::Exceptions::UnsupportedPlatform.new(node['kernel']['machine'].to_s)
end

default['lyraphase_workstation']['bitfocus_companion']['dmg']['volumes_dir'] = 'Companion 2.2.0'
default['lyraphase_workstation']['bitfocus_companion']['dmg']['app']         = 'Companion'
default['lyraphase_workstation']['bitfocus_companion']['dmg']['type']        = 'app'
default['lyraphase_workstation']['bitfocus_companion']['dmg']['package_id']  = 'companion.bitfocus.no'
# rubocop:enable Metrics/LineLength
