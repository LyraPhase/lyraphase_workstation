lyraphase_workstation cookbook
==============================
<noscript><a href="https://liberapay.com/trinitronx/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a></noscript>
[![Build Status](http://img.shields.io/travis/trinitronx/lyraphase_workstation.svg)](https://travis-ci.org/trinitronx/lyraphase_workstation)

A cookbook including various recipes for installing tools used by myself.
This includes Ableton Live [DAW][1], VSTs, and other various tools and utilities.

# Requirements

 - Mac OS X

# Usage

Include the recipes you want in your Chef `run_list`, or in your [`soloistrc` file][sprout-wrap].

**NOTE:** The default URLs for non-free applications **will not work for you**.  You must host your own `.dmg` and app install files.  Please see the recipe's cooresponding `attributes` file for examples.  All checksums are SHA256, and can be found via `shasum -a 256 path/to/file/here.dmg`.

You may decide to create a DAW Chef Role such as:

`roles/osx-daw.json`:

    {
      "json_class": "Chef::Role",
      "name": "osx-daw",
      "description": "Role for configuring OSX as a Digital Audio Workstation",
      "override_attributes": {
        "homebrew": {
          "casks": [
            "keyfinder",
            "soundflower",
            "audacity"
          ]
        },
        "lyraphase_workstation": {
          "ableton_live": {
            "managed_versions": "all",
            "options": ["EnableMapToSiblings"],
            "dmg": {
              "source": "http://www.example.com/mac/dmgs/ableton_live_suite_10.0.1_64.dmg",
              "checksum": "73f8b7d9c2e058639466cbb765e6e1610f97f542745e2c69567d7bf55a407e11",
              "volumes_dir": "Ableton Live 10 Suite Installer",
              "dmg_name": "ableton_live_suite_10.0.1_64",
              "app": "Ableton Live 10 Suite"
            }
          }
        }
      },
      "run_list": [
        "recipe[lyraphase_workstation::airfoil]",
        "recipe[lyraphase_workstation::ableton_live]",
        "recipe[lyraphase_workstation::ableton_live_options]",
        "recipe[lyraphase_workstation::max_for_live]",
        "recipe[lyraphase_workstation::traktor]",
        "recipe[lyraphase_workstation::traktor_audio_2]",
        "recipe[lyraphase_workstation::dmgaudio_dualism]",
        "recipe[lyraphase_workstation::oxium]",
        "recipe[lyraphase_workstation::polyverse_infected_mushroom_i_wish]",
        "recipe[lyraphase_workstation::mixed_in_key]",
        "recipe[lyraphase_workstation::korg_kontrol_editor]",
        "recipe[lyraphase_workstation::sublime_text_settings]",
        "recipe[lyraphase_workstation::nfs_mounts]",
        "recipe[lyraphase_workstation::bash_it_custom_plugins]",
        "recipe[lyraphase_workstation::daisydisk]",
        "recipe[lyraphase_workstation::drobo_dashboard]",
        "recipe[lyraphase_workstation::prolific_pl2303_driver]"
      ]
    }

There are also some non-DAW related recipes included in this cookbook.

You may also decide to create a development tool Chef Role such as:

`roles/osx-development.json`:

    {
      "json_class": "Chef::Role",
      "name": "osx-development",
      "description": "Role for configuring OSX with developer tools",
      "override_attributes": {
        "lyraphase_workstation": {
          "nfs_mounts": [
            "/../Volumes/my-nfs-mount    -fstype=nfs,nolockd,resvport,hard,bg,intr,rw,tcp,nfc nfs://nfs-server.example.com:/export/my-nfs-mount"
          ]
        }
      },
      "run_list": [
        "recipe[sublime_text_settings]",
        "recipe[nfs_mounts]",
        "recipe[homebrew_sudoers]",
        "recipe[iterm2_shell_integration]",
        "recipe[bash4]",
        "recipe[bash_it_custom_plugins]",
        "recipe[gpg21]"
      ]
    }

To use the `sublime_text_settings` recipe, place your Sublime Text 3 Application Data folders under `"#{node['lyraphase_workstation']['home']}/pCloud Drive/AppData/mac/sublime-text-3/`.  The recipe will create [Symbolic Links][symlink] to these files in the usual location: `"#{node['lyraphase_workstation']['home']}/Library/Application Support/Sublime Text 3/`.

The result is that your Sublime Text 3 folders get synced to pCloud, and Sublime Text can look for them in the default location, follow the symlink to the pCloud destination files.

The `nfs_mounts` recipe will just mount things in the list of `nfs_mounts` for you.  The `/../` part in front of `/../Volumes/` happens to be important!  The reason is because the OSX `/etc/auto_nfs` file does not usually want to mount things under `/Volumes`.  Putting the `/../` in front allows you to use automount to mount NFS volumes there.

The `homebrew_sudoers` recipe uses the included `templates/default/sudoers.d/homebrew_chef.erb` template to fix `sudo` permissions when running `chef-client` or `soloist` to provision your OSX machine.  Without this, you may be asked for `sudo` password far too many times than is feasible to type.  The included `sudoers.d` file drop-in allows the [`homebrew` cookbook][homebrew-cookbook] to run the [commands it needs][homebrew-sudo-bug] via passwordless `sudo`.

The `iterm2_shell_integration` recipe installs iTerm via `iterm` recipe, and then [iTerm2 Shell Integration][iterm2-shell] via script url `https://iterm2.com/misc/install_shell_integration.sh`. Checksum may not be kept up to date, but you can change this.  See the recipe's attributes (`attributes/iterm2_shell_integration.rb`).

The `iterm` recipe installs iTerm via [Homebrew](https://brew.sh). It then installs my default preferences file via template `templates/default/com.googlecode.iterm2.plist.erb`.  You may not want this and may want to use a wrapper cookbook that just calls `include_recipe 'iterm'` so you can override my template.


The `bash4` recipe installs Bash version 4 via Homebrew and changes your login shell. It also configures `/etc/shells` with a list of shells from attribute `node['lyraphase_workstation']['bash']['etc_shells']`. If you do not want to reset your login shell to bash from Homebrew, set `default['lyraphase_workstation']['bash']['set_login_shell'] = false`. The `etc_shells_path` is also configurable (see `attributes/bash4.rb`).

The `bash_it_custom_plugins` recipe uses `sprout-base::bash_it` to install a list of plugins for [Bash-it][bash-it].  The default list is in `node.default['lyraphase_workstation']['bash_it']['custom_plugins']`.  See the [`sprout-base` cookbook][sprout-base] for more details.

The `gpg21` recipe installs GnuPG version 2.1 via `homebrew/versions` Homebrew Tap. It ensures that old symlinks to gpg binaries are deleted (configurable via `node['lyraphase_workstation']['gpg21']['binary_paths']`).  Only symlinks are unlinked, no old binaries should be harmed.  The recipe also installs a helper script to `/usr/local/bin/fixGpgHome`, and a `LaunchAgents` to `/Library/LaunchAgents/com.lyraphase.gpg21.fix.plist`.  Finally, it sets `RunAtLoad: false` for the original `/Library/LaunchAgents/org.gpgtools.macgpg2.fix.plist` file.  The reason for this set of patches is because the original LaunchAgent has hardcoded references to the old GnuPG binaries, and you may end up getting confused as to which version of GPG you are really using from `gpg-agent`, `gpg`, and `gpg2`.  This recipe sets them all to the new `gpg21` binaries from Homebrew.  Finally, it adds `StreamLocalBindUnlink yes` to your `/etc/ssh/sshd_config` so you may use `gpg-agent` forwarding over SSH.


## Sponsor

If you find this project useful and appreciate my work,
would you be willing to click one of the buttons below to Sponsor this project and help me continue?

- <noscript><a href="https://github.com/sponsors/trinitronx">:heart: Sponsor</a></noscript>
- <noscript><a href="https://liberapay.com/trinitronx/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a></noscript>
- <noscript><a href="https://paypal.me/JamesCuzella"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" alt="Donate with PayPal" /></a></noscript>

Every little bit is appreciated! Thank you! 🙏


# Attributes

Too many to list!  Please see the appropriate recipe's `attributes/<recipe_here>.rb` file for details.

Some general rules of thumb:

 - `.dmg` file installers usually have the following attributes:
   - `['lyraphase_workstation']['recipe_here']['dmg']`: A set of attributes describing the DMG such as:
     - `['source']`: A source URL for Chef to download the DMG installer from.  **You must set your own!** I do not intend to host these for anyone else!
     - `['checksum']`: A SHA256 checksum of the `.dmg` file.  Get this via `shasum -a 256 your-file.dmg` OR on *nix systems `sha256sum your-file.dmg`.
     - `['volumes_dir']`: Directory name that the `.dmg` will expected to be mounted under `/Volumes/`.
     - `['dmg_name']`: Name of the `.dmg` file without the `.dmg` suffix.  That's it!
     - `['app']`: Name of the `.app` folder inside the mounted `.dmg`.  This maps to `/Volumes/dmg_name/app_name_here.app`.
     - `['type']`: Type of application the [dmg cookbook][dmg-cookbook] will install.  This can be one of: `app`, `mkpg`, `pkg`. **Default: '`app`'**
 - `.zip` file app installations usually have these attributes:
   - `['lyraphase_workstation']['recipe_here']['zip']`: A set of attributes describing the `.zip` file:
     - `['zip']['source']`: A source URL for Chef to download the ZIP archive from.  **Again: You must set your own!** I do not intend to host these for anyone else!
     - `['zip']['checksum']`:  A SHA256 checksum of the `.zip` file.  Get this via `shasum -a 256 your-file.zip` OR on *nix systems `sha256sum your-file.zip`.
 - Some recipes have support for License Keys. To use these there are two methods:
     - `['license']` data inside Chef Attributes
       - Just set the attributes like you normally would and the recipe will use them
     - `['license']` data inside [Encrypted Data Bags][data-bags]
       - Check the recipe `.rb` file for the Encrypted Data Bag name, then create an encrypted data bag with the same data structure as you would put under `['license']`.  You may wish to use the [`knife-solo_data_bag` gem][knife-solo_data_bag] to assist in operating on plain files.  If you have a Chef Server, use the normal `knife` commands to operate on the data bags.
       - If the recipe finds an Encrypted Data Bag with `['license']` data (`Hash`), it will override the Attributes and use this instead.

# Recipes

 - `lyraphase_workstation::ableton_live`: Install [Ableton Live](https://www.ableton.com/) DAW
 - `lyraphase_workstation::ableton_live_options`: Manage [Options.txt](https://help.ableton.com/hc/en-us/articles/209772865-Options-txt-file-for-Live) settings for [Ableton Live](https://www.ableton.com/) DAW
 - `lyraphase_workstation::airfoil`: Install [Airfoil](https://www.rogueamoeba.com/airfoil/)
 - `lyraphase_workstation::bash4`: Install [bash v4](https://github.com/Homebrew/homebrew-core/blob/master/Formula/bash.rb) from Homebrew
 - `lyraphase_workstation::cycling_74_max`: Install [CYCLING '74 MAX](https://cycling74.com/)
 - `lyraphase_workstation::daisydisk`: Install [DaisyDisk](http://www.daisydiskapp.com/)
 - `lyraphase_workstation::default`: No-Op recipe for just loading libraries this cookbook provides
 - `lyraphase_workstation::dmgaudio_dualism`: Install [DMGAudio Dualism](http://www.dmgaudio.com/products_dualism.php)
 - `lyraphase_workstation::drobo_dashboard`: Install [Drobo Dashboard](http://www.drobo.com/start/)
 - `lyraphase_workstation::korg_kontrol_editor`: Install [Korg Kontrol Editor](http://www.korg.com/us/support/download/software/1/253/1355/) ([Manual](http://www.korg.com/us/support/download/manual/1/253/1843/) [Archived DL](https://web.archive.org/web/20150919212752/http://www.korg.com/filedl/61a78cbcf754384af8104114d7cde1c7/840/download.php))
 - `lyraphase_workstation::max_for_live`: Install [Max for Live](https://www.ableton.com/en/live/max-for-live/)
 - `lyraphase_workstation::mixed_in_key`: Install [Mixed In Key](http://www.mixedinkey.com)
 - `lyraphase_workstation::multibit`: Install [Multibit](https://multibit.org/)
 - `lyraphase_workstation::musicbrainz_picard`: Install [MusicBrainz Picard](https://picard.musicbrainz.org/)
 - `lyraphase_workstation::nfs_mounts`: Manage /etc/auto_nfs entries for [NFS Client mounts on OS X](https://coderwall.com/p/fuoa-g/automounting-nfs-share-in-os-x-into-volumes)
 - `lyraphase_workstation::omnifocus`: Install [OmniFocus](https://www.omnigroup.com/omnifocus)
 - `lyraphase_workstation::oxium`: Install [Xils-Lab Oxium](http://www.xils-lab.com/pages/Oxium.html) Synthesizer
 - `lyraphase_workstation::polyverse_infected_mushroom_i_wish`: Install [Polyverse - Infected Mushroom - I Wish VST](http://polyversemusic.com/)
 - `lyraphase_workstation::prolific_pl2303_driver`: Install [Prolific PL2303 Driver](http://www.prolific.com.tw/US/ShowProduct.aspx?p_id=229&pcid=41)
 - `lyraphase_workstation::sublime_text_settings`: Installs Settings symlinks for storing [Sublime Text](http://www.sublimetext.com/) configs in pCloud Drive
 - `lyraphase_workstation::traktor`: Installs [Traktor](http://www.native-instruments.com/en/products/traktor/) DJ software
 - `lyraphase_workstation::traktor_audio_2`: Installs [Traktor Audio 2 DJ](http://www.native-instruments.com/en/products/traktor/dj-audio-interfaces/traktor-audio-2/) Driver
 - `lyraphase_workstation::vimrc`: Installs vimrc via git repo
 - `lyraphase_workstation::xcode`: Install XCode via .dmg and accepts XCode build license

# Author

Author:: James Cuzella ([@trinitronx][keybase-id])

[1]: https://en.wikipedia.org/wiki/Digital_audio_workstation
[keybase-id]: https://gist.github.com/trinitronx/aee110cbdf55e67185dc44272784e694
[sprout-wrap]: https://github.com/trinitronx/sprout-wrap/
[dmg-cookbook]: https://github.com/chef-cookbooks/dmg
[data-bags]: https://docs.chef.io/data_bags.html
[knife-solo_data_bag]: https://github.com/thbishop/knife-solo_data_bag
[symlink]: https://en.wikipedia.org/wiki/Symbolic_link
[homebrew-cookbook]: https://github.com/chef-cookbooks/homebrew
[homebrew-sudo-bug]: https://github.com/chef-cookbooks/homebrew/issues/105
[iterm2-shell]: https://www.iterm2.com/documentation-shell-integration.html
[bash-it]: https://github.com/Bash-it/bash-it
[sprout-base]: https://github.com/pivotal-sprout/sprout-base
