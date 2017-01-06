default['lyraphase_workstation']['ableton_live'] = {}
default['lyraphase_workstation']['ableton_live']['dmg'] = {}
default['lyraphase_workstation']['ableton_live']['dmg']['source']      = 'http://www.lyraphase.com/doc/installers/mac/ableton_live_suite_9.7_64.dmg'
default['lyraphase_workstation']['ableton_live']['dmg']['checksum']    = "35fa16a2c703d458fc005413e81e7fccd3ebf18eff5bffea91eb9165db42c400"
default['lyraphase_workstation']['ableton_live']['dmg']['volumes_dir'] = "Ableton Live 9 Suite Installer"
default['lyraphase_workstation']['ableton_live']['dmg']['dmg_name']    = 'ableton_live_suite_9.7_64'
default['lyraphase_workstation']['ableton_live']['dmg']['app']         = 'Ableton Live 9 Suite'
default['lyraphase_workstation']['ableton_live']['dmg']['type']        = 'app'
Chef::Log.warn("INSIDE COOKBOOK ATTRIBUTES FILE: Loaded Attributes for: lyraphase_workstation::ableton_live Recipe")
Chef::Log.warn("INSIDE COOKBOOK ATTRIBUTES FILE: is node['lyraphase_workstation']['ableton_live']['dmg'] a kind of Hash? #{node['lyraphase_workstation']['ableton_live']['dmg'].kind_of?(Hash)}")
Chef::Log.warn("INSIDE COOKBOOK ATTRIBUTES FILE: Class of node['lyraphase_workstation']['ableton_live']['dmg'] is: #{node['lyraphase_workstation']['ableton_live']['dmg'].class}")