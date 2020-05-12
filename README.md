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

**NOTE:** The default URLs for non-free applications **_may_ not work for you**.  You may want to host your own `.dmg` and app install files.  Please see the recipe's cooresponding `attributes` file for examples.  All checksums are SHA256, and can be found via `shasum -a 256 path/to/file/here.dmg`.

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
 - `lyraphase_workstation::bash_it_custom_plugins`: Install some custom plugins for [bash-it](https://github.com/Bash-it/bash-it):
   - `git-custom_subdir_gitconfig.aliases`: Alias for `git` to support [custom `.gitemail` author & email config files](https://gist.github.com/trinitronx/5979265).
     - For example: Commit public repos as personal email & ID
     - Commit to work repos as corporate email & ID.)
   - `less-manpage-colors.bash`: Set `LESS_TERMCAP_*` environment variables for Manpage colors in `less` Pager.
     - Config color scheme was lifted from [Amazon Linux](https://forums.aws.amazon.com/thread.jspa?threadID=245139)
 - `lyraphase_workstation::cycling_74_max`: Install [CYCLING '74 MAX](https://cycling74.com/)
 - `lyraphase_workstation::daisydisk`: Install [DaisyDisk](http://www.daisydiskapp.com/)
 - `lyraphase_workstation::default`: No-Op recipe for just loading libraries this cookbook provides
 - `lyraphase_workstation::dmgaudio_dualism`: Install [DMGAudio Dualism](http://www.dmgaudio.com/products_dualism.php)
 - `lyraphase_workstation::drobo_dashboard`: Install [Drobo Dashboard](http://www.drobo.com/start/)
 - `lyraphase_workstation::gpg21`: Install GnuPG 2.1 via `homebrew/versions` Homebrew Tap
   - Note that many old Homebrew Taps have been deprecated, [including `homebrew/versions`](https://web.archive.org/web/20190128084759/https://github.com/Homebrew/homebrew-versions)
   - Homebrew [`gpg-suite`](https://gpgtools.org/) recipe `version 2019.2` now installs `gpg (GnuPG/MacGPG2) 2.2.17`!
   - Therefore this recipe is only for legacy support purposes and it's recommended to migrate off this version. This recipe will eventually be deprecated.
 - `lyraphase_workstation::hammerspoon`: 'Install [Hammerspoon](http://www.hammerspoon.org) ([GitHub](https://github.com/Hammerspoon/hammerspoon))
 - `lyraphase_workstation::hammerspoon_shiftit`: Install ShiftIt replacement: [MiroWindowManager.spoon](http://www.hammerspoon.org/Spoons/MiroWindowsManager.html) ([GitHub](https://github.com/miromannino/miro-windows-manager) [ShiftIt Deprecated](https://github.com/fikovnik/ShiftIt/issues/299#issuecomment-469419329))
 - `lyraphase_workstation::homebrew_sudoers`: Install `/etc/sudoers.d/homebrew_chef` config settings to fix `sudo` permissions when running `chef-client` or `soloist` to provision your OSX machine.
   - Without this, you may be asked for `sudo` password far too many times than is feasible to type!
   - The included `sudoers.d` file drop-in allows the [`homebrew` cookbook][homebrew-cookbook] to run the [commands it needs][homebrew-sudo-bug] via passwordless `sudo`.
 - `lyraphase_workstation::korg_kontrol_editor`: Install [Korg Kontrol Editor](http://www.korg.com/us/support/download/software/1/253/1355/) ([Manual](http://www.korg.com/us/support/download/manual/1/253/1843/) [Archived DL](https://web.archive.org/web/20150919212752/http://www.korg.com/filedl/61a78cbcf754384af8104114d7cde1c7/840/download.php))
 - `lyraphase_workstation::loopback_alias_ip`: Install [loopback alias IP LaunchDaemon](https://github.com/trinitronx/lyraphase_workstation/blob/master/templates/default/com.runlevel1.lo0.alias.plist.erb) for[SSH Tunneled Proxy Access to VPC / Private Network from a Docker Container][ssh-tunnel-docs]
   - Adds support for local [SSH tunnel port forwarding across Docker bridge networks](https://gist.github.com/trinitronx/6427d6454fb3b121fc2ab5ca7ac766bc).
   - Use case for `terraform` [explained here](https://github.com/hashicorp/terraform/issues/17754#issuecomment-383227407).  **Note:** GoLang `net` library must still add SOCKS5**h** support for hostname DNS lookup through the tunnel!
   - Any tool supporting `socks5h://` protocol via `HTTP_PROXY`, `HTTPS_PROXY` environment variables should work fine! (e.g.: `curl`, `wget`, etc...)
   - How to use:
     - Install the `LaunchDaemon` with this recipe.
     - Set up SSH `DynamicForward` tunnel using the Alias IP set in `node['lyraphase_workstation']['loopback_alias_ip']['alias_ip']` attribute. (Default: `172.16.222.111`)
       - **Note:** The `alias_ip` should be in a network range designated as [Private Address Space by IANA](https://www.arin.net/reference/research/statistics/address_filters/)
       - Default `alias_ip` (`172.16.222.111`) is configured to be in the `172.16.0.0/12` _not_ publicly routable private IPv4 range.
     - Run a Docker container, passing the configured Alias IP via standard `*_PROXY` environment variables
       - For example: 
         - `export PROTO='socks5h://'; export IP=172.16.222.111; export PORT=2903;`
         - `ssh -f -N -v -D ${IP}:${PORT} ssh-bastion-host.example.com`
         - `export ALL_PROXY="${PROTO}${IP}:${PORT}";  HTTP_PROXY="$ALL_PROXY" HTTPS_PROXY="$ALL_PROXY"`
         - Set up Docker Networking: `docker network create -d bridge --subnet 10.1.123.0/22 --gateway 10.1.123.1 bridgenet`
         - Then pass the proxy to `docker run ... `: `--net=bridgenet -e HTTP_PROXY=HTTP_PROXY -e HTTPS_PROXY=HTTPS_PROXY -e ALL_PROXY=ALL_PROXY`
         - Alternatively, use a hostname inside the container's `/etc/hosts`: `--add-host proxy.local:$IP`
           - `export ALL_PROXY=socks5h://proxy.local:2903; export HTTPS_PROXY=$ALL_PROXY; export HTTP_PROXY=$ALL_PROXY;`
           - `curl -v http://your-service.vpc.local`
         - More complete docs & example [can be found here][ssh-tunnel-docs]
 - `lyraphase_workstation::max_for_live`: Install [Max for Live](https://www.ableton.com/en/live/max-for-live/)
 - `lyraphase_workstation::mixed_in_key`: Install [Mixed In Key](http://www.mixedinkey.com)
 - `lyraphase_workstation::multibit`: Install [Multibit](https://multibit.org/)
 - `lyraphase_workstation::musicbrainz_picard`: Install [MusicBrainz Picard](https://picard.musicbrainz.org/)
 - `lyraphase_workstation::nfs_mounts`: Manage /etc/auto_nfs entries for [NFS Client mounts on OS X](https://coderwall.com/p/fuoa-g/automounting-nfs-share-in-os-x-into-volumes)
 - `lyraphase_workstation::omnifocus`: Install [OmniFocus](https://www.omnigroup.com/omnifocus)
 - `lyraphase_workstation::osx_autohide_dock`: Enable AutoHide OSX Dock, with default `autohide-delay`.
   - [AutoHide Delay](https://www.defaults-write.com/remove-the-dock-auto-hide-show-delay/) is configurable via node attribute: `node['lyraphase_workstation']['settings']['autohide_delay']`.
   - AutoHide Enable / Disable can be controlled via: `node['lyraphase_workstation']['settings']['autohide_dock']`
 - `lyraphase_workstation::osx_natural_scrolling`: Enable Natural Mouse Scrolling OSX setting `com.apple.swipescrolldirection` for a more natural & intuitive TouchPad scrolling direction.
   - Enable / Disable via: `node['lyraphase_workstation']['settings']['natural_scrolling']`
   - Natural Scrolling on: Scrolling up/down behaves as if you are swiping a piece of paper in the physical world
     - fingers up = page down
     - fingers down = page up
   - Natural Scrolling off: Scrolling up/down is exactly the same as the direction you are moving your fingers
     - fingers up = page up
     - fingers down = page down
 - `lyraphase_workstation::oxium`: Install [Xils-Lab Oxium](http://www.xils-lab.com/pages/Oxium.html) Synthesizer
 - `lyraphase_workstation::polyverse_infected_mushroom_i_wish`: Install [Polyverse - Infected Mushroom - I Wish VST](https://polyversemusic.com/products/i-wish/)
 - `lyraphase_workstation::polyverse_infected_mushroom_manipulator`: Install [Polyverse - Infected Mushroom - Manipulator VST](https://polyversemusic.com/products/manipulator/)
 - `lyraphase_workstation::prolific_pl2303_driver`: Install [Prolific PL2303 Driver](http://www.prolific.com.tw/US/ShowProduct.aspx?p_id=229&pcid=41)
 - `lyraphase_workstation::ssh_tunnel_port_override`: Install [`ssh-tunnel-port-override.sh` script](https://github.com/trinitronx/lyraphase_workstation/blob/master/templates/default/ssh-tunnel-port-override.sh.erb) & `LaunchDaemon` to allow killing some process (_cough_ McAfee -Anti-virus _cough_ 🦠😷) that claims your favorite SSH tunnel port (Default: `8081`) on login.
   - Will kill the process so long as `SSH Tunnel` App has not claimed the port yet.
   - Supports CPU soft limit throttling via `SIGXCPU`, as supported by `launchd`!
   - Logs to file: `/var/log/ssh-tunnel-override.log`
 - `lyraphase_workstation::sublime_text_settings`: Installs Settings symlinks for storing [Sublime Text](http://www.sublimetext.com/) configs in pCloud Drive
 - `lyraphase_workstation::trackspacer`: Installs [WavesFactory TrackSpacer VST](https://www.wavesfactory.com/trackspacer/) plugin.
 - `lyraphase_workstation::traktor`: Installs [Traktor](http://www.native-instruments.com/en/products/traktor/) DJ software
 - `lyraphase_workstation::traktor_audio_2`: Installs [Traktor Audio 2 DJ](http://www.native-instruments.com/en/products/traktor/dj-audio-interfaces/traktor-audio-2/) Driver
   - **Note:** Apple deprecated `kext`/ Kernel Extension drivers in macOS Catalina 10.15.
   - Native Instruments has also officially deprecated this driver for Audio 2 _version 1_, which is now considered a Legacy device.
   - The Audio 2 _version 2_ should still operate without a `kext` driver as a USB class-compliant device.
   - As such, the driver installed by this recipe may not work properly in later versions of `macOS >= 10.15.x`
   - The Traktor Audio 2 version 1 is **still supported** on Linux by the [`snd-usb-caiaq`](https://www.alsa-project.org/wiki/Matrix:Module-usb-caiaq) Kernel Module!
   - Therefore, this device is a **good choice** for Linux & embedded systems projects, and is known to work with Open Source drivers on Intel Edison, Raspberry Pi, etc...
   - [Mixxx has some notes about Native Instruments devices & controllers here](https://www.mixxx.org/wiki/doku.php/hardware_compatibility).
   - This device luckily does not send NHL nor MIDI, it is just a simple 2 channel sound card!
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
[ssh-tunnel-docs]: https://github.com/trinitronx/lyraphase_workstation/blob/master/docs/SSH%20Tunneled%20Proxy%20Access%20to%20VPC%20from%20Docker%20Container.md
