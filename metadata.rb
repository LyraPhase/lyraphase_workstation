name             "lyraphase_workstation"
maintainer       "James Cuzella"
maintainer_email "james.cuzella@lyraphase.com"
license          "GPL-3.0+"
description      "Recipes to Install & Configure my workstation"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.3.0"
chef_version     ">= 12.0" if respond_to?(:chef_version)

source_url 'https://github.com/trinitronx/lyraphase_workstation' if respond_to?(:source_url)
issues_url 'https://github.com/trinitronx/lyraphase_workstation/issues' if respond_to?(:issues_url)

require 'chef/version_constraint'

supports         'mac_os_x'
depends          'homebrew'
depends          'dmg' unless respond_to?(:chef_version) and Chef::const_defined?(:VERSION) and Chef::VersionConstraint.new(">= 10.14.0").include?(Chef::VERSION.to_s)
depends          'osx' # For osx_defaults LWRP
depends          'sprout-base'  # For `libraries/directory#recursive_directories()` function
depends          'plist', '~> 0.9' # For `plist_file` LWRP (used in lyraphase_workstation::airfoil recipe)

recipe 'lyraphase_workstation::ableton_live', 'Install [Ableton Live](https://www.ableton.com/) DAW'
recipe 'lyraphase_workstation::ableton_live_options', 'Manage [Options.txt](https://help.ableton.com/hc/en-us/articles/209772865-Options-txt-file-for-Live) settings for [Ableton Live](https://www.ableton.com/) DAW'
recipe 'lyraphase_workstation::airfoil', 'Install [Airfoil](https://www.rogueamoeba.com/airfoil/)'
recipe 'lyraphase_workstation::bash4', 'Install [bash v4](https://github.com/Homebrew/homebrew-core/blob/master/Formula/bash.rb) from Homebrew'
recipe 'lyraphase_workstation::cycling_74_max', 'Install [CYCLING \'74 MAX](https://cycling74.com/)'
recipe 'lyraphase_workstation::daisydisk', 'Install [DaisyDisk](http://www.daisydiskapp.com/)'
recipe 'lyraphase_workstation::default', 'No-Op recipe for just loading libraries this cookbook provides'
recipe 'lyraphase_workstation::dmgaudio_dualism', 'Install [DMGAudio Dualism](http://www.dmgaudio.com/products_dualism.php)'
recipe 'lyraphase_workstation::drobo_dashboard', 'Install [Drobo Dashboard](http://www.drobo.com/start/)'
recipe 'lyraphase_workstation::hammerspoon', 'Install [Hammerspoon](http://www.hammerspoon.org) ([GitHub](https://github.com/Hammerspoon/hammerspoon))'
recipe 'lyraphase_workstation::hammerspoon_shiftit', 'Install ShiftIt replacement: [MiroWindowManager.spoon](http://www.hammerspoon.org/Spoons/MiroWindowsManager.html) ([GitHub](https://github.com/miromannino/miro-windows-manager) [ShiftIt Deprecated](https://github.com/fikovnik/ShiftIt/issues/299#issuecomment-469419329))'
recipe 'lyraphase_workstation::korg_kontrol_editor', 'Install [Korg Kontrol Editor](http://www.korg.com/us/support/download/software/1/253/1355/) ([Manual](http://www.korg.com/us/support/download/manual/1/253/1843/) [Archived DL](https://web.archive.org/web/20150919212752/http://www.korg.com/filedl/61a78cbcf754384af8104114d7cde1c7/840/download.php))'
recipe 'lyraphase_workstation::max_for_live', 'Install [Max for Live](https://www.ableton.com/en/live/max-for-live/)'
recipe 'lyraphase_workstation::mixed_in_key', 'Install [Mixed In Key](http://www.mixedinkey.com)'
recipe 'lyraphase_workstation::multibit', 'Install [Multibit](https://multibit.org/)'
recipe 'lyraphase_workstation::musicbrainz_picard', 'Install [MusicBrainz Picard](https://picard.musicbrainz.org/)'
recipe 'lyraphase_workstation::nfs_mounts', 'Manage /etc/auto_nfs entries for [NFS Client mounts on OS X](https://coderwall.com/p/fuoa-g/automounting-nfs-share-in-os-x-into-volumes)'
recipe 'lyraphase_workstation::omnifocus', 'Install [OmniFocus](https://www.omnigroup.com/omnifocus)'
recipe 'lyraphase_workstation::oxium', 'Install [Xils-Lab Oxium](http://www.xils-lab.com/pages/Oxium.html) Synthesizer'
recipe 'lyraphase_workstation::polyverse_infected_mushroom_i_wish', 'Install [Polyverse - Infected Mushroom - I Wish VST](http://polyversemusic.com/)'
recipe 'lyraphase_workstation::prolific_pl2303_driver', 'Install [Prolific PL2303 Driver](http://www.prolific.com.tw/US/ShowProduct.aspx?p_id=229&pcid=41)'
recipe 'lyraphase_workstation::sublime_text_settings', 'Installs Settings symlinks for storing [Sublime Text](http://www.sublimetext.com/) configs in Dropbox'
recipe 'lyraphase_workstation::traktor', 'Installs [Traktor](http://www.native-instruments.com/en/products/traktor/) DJ software'
recipe 'lyraphase_workstation::traktor_audio_2', 'Installs [Traktor Audio 2 DJ](http://www.native-instruments.com/en/products/traktor/dj-audio-interfaces/traktor-audio-2/) Driver'
recipe 'lyraphase_workstation::vimrc', 'Installs vimrc via git repo'
recipe 'lyraphase_workstation::xcode', 'Install XCode via .dmg and accepts XCode build license'
