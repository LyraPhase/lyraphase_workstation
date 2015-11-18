require 'chef/version_constraint'
# Chef::Log.info("Platform Version: #{node['platform_version']}")
# Chef::Log.info("Platform Version <  10.10 ? #{Chef::VersionConstraint.new("< 10.10").include?(node['platform_version'])}")
# Chef::Log.info("Platform Version >= 10.10 ? #{Chef::VersionConstraint.new(">= 10.10").include?(node['platform_version'])}")

if Chef::VersionConstraint.new("< 10.9").include?(node['platform_version'])
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['source']      = 'http://lyraphase.com/doc/installers/mac/Traktor_Audio_2_270_Mac_p.dmg'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['checksum']    = "e73d7ce1d023297e8081ae72c8cb23539efc18ed7c549df7ef5e19590c72d54e"
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['volumes_dir'] = "Traktor Audio 2"
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['dmg_name']    = 'Traktor_Audio_2_270_Mac_p'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['app']         = 'Traktor Audio 2 2.7.0 Installer Mac'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['type']        = 'pkg'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['package_id']  = 'com.caiaq.NIUSBTraktorAudio2Driver_10.9'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['cf_bundle_id'] = 'com.caiaq.driver.NIUSBTraktorAudio2Driver'
elsif Chef::VersionConstraint.new(">= 10.9").include?(node['platform_version'])
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['source']      = 'http://lyraphase.com/doc/installers/mac/Traktor_Audio_2_280_Mac_p.dmg'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['checksum']    = "c2a32f6d60bad7d18794b02f7c4a4b35f273e93d32e784373eba57e0cfcd4b97"
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['volumes_dir'] = "Traktor Audio 2"
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['dmg_name']    = 'Traktor_Audio_2_280_Mac_p'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['app']         = 'Traktor Audio 2 2.8.0 Installer Mac'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['type']        = 'pkg'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['package_id']  = 'com.caiaq.NIUSBTraktorAudio2Driver_10.10'
  default['lyraphase_workstation']['traktor_audio_2']['dmg']['cf_bundle_id'] = 'com.caiaq.driver.NIUSBTraktorAudio2Driver'
end
