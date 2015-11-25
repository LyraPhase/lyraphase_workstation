name             "lyraphase_workstation"
maintainer       "James Cuzella"
maintainer_email "james.cuzella@lyraphase.com"
license          "GNU Public License 3.0"
description      "Recipes to Install & Configure my workstation"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.7.2"

source_url 'https://github.com/trinitronx/lyraphase_workstation' if respond_to?(:source_url)
issues_url 'https://github.com/trinitronx/lyraphase_workstation/issues' if respond_to?(:issues_url)

supports         'mac_os_x'
depends          'homebrew'
depends          'dmg'
depends          'osx' # For osx_defaults LWRP
depends          'sprout-base'  # For `libraries/directory#recursive_directories()` function

recipe 'lyraphase_workstation::ableton_live', 'Install [Ableton Live](https://www.ableton.com/) DAW'
recipe 'lyraphase_workstation::cycling_74_max', 'Install [CYCLING ‘74 MAX](https://cycling74.com/)'
recipe 'lyraphase_workstation::daisydisk', 'Install [DaisyDisk](http://www.daisydiskapp.com/)'
recipe 'lyraphase_workstation::default', 'No-Op recipe for just loading libraries this cookbook provides'
recipe 'lyraphase_workstation::dmgaudio_dualism', 'Install [DMGAudio Dualism](http://www.dmgaudio.com/products_dualism.php)'
recipe 'lyraphase_workstation::drobo_dashboard', 'Install [Drobo Dashboard](http://www.drobo.com/start/)'
recipe 'lyraphase_workstation::korg_kontrol_editor', 'Install [Korg Kontrol Editor](http://www.korg.com/us/support/download/software/1/253/1355/) ([Manual](http://www.korg.com/us/support/download/manual/1/253/1843/) [Archived DL](https://web.archive.org/web/20150919212752/http://www.korg.com/filedl/61a78cbcf754384af8104114d7cde1c7/840/download.php))'
recipe 'lyraphase_workstation::max_for_live', 'Install [Max for Live](https://www.ableton.com/en/live/max-for-live/)'
recipe 'lyraphase_workstation::mixed_in_key', 'Install [Mixed In Key](http://www.mixedinkey.com)'
recipe 'lyraphase_workstation::multibit', 'Install [Multibit](https://multibit.org/)'
recipe 'lyraphase_workstation::musicbrainz_picard', 'Install [MusicBrainz Picard](https://picard.musicbrainz.org/)'
recipe 'lyraphase_workstation::nfs_mounts', 'Manage /etc/auto_nfs entries for [NFS Client mounts on OS X](https://coderwall.com/p/fuoa-g/automounting-nfs-share-in-os-x-into-volumes)'
recipe 'lyraphase_workstation::omnifocus', 'Install [OmniFocus](https://www.omnigroup.com/omnifocus)'
recipe 'lyraphase_workstation::oxium', 'Install [Xils-Lab Oxium](http://www.xils-lab.com/pages/Oxium.html) Synthesizer'
recipe 'lyraphase_workstation::polyverse_infected_mushroom_i_wish', 'Install [Polyverse - Infected Mushroom - I Wish VST](http://polyversemusic.com/)'
recipe 'lyraphase_workstation::sublime_text_settings', 'Installs Settings symlinks for storing [Sublime Text](http://www.sublimetext.com/) configs in Dropbox'
recipe 'lyraphase_workstation::traktor', 'Installs [Traktor](http://www.native-instruments.com/en/products/traktor/) DJ software'
recipe 'lyraphase_workstation::traktor_audio_2', 'Installs [Traktor Audio 2 DJ](http://www.native-instruments.com/en/products/traktor/dj-audio-interfaces/traktor-audio-2/) Driver'
recipe 'lyraphase_workstation::vimrc', 'Installs vimrc via git repo'
recipe 'lyraphase_workstation::xcode', 'Install XCode via .dmg and accepts XCode build license'
