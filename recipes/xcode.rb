# -*- coding: utf-8 -*-
# frozen_string_literal: true

#
# Cookbook:: lyraphase_workstation
# Recipe:: xcode
# Site:: https://developer.apple.com/xcode/
#
# License:: GPL-3.0+
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
#

dmg_properties = node['lyraphase_workstation']['xcode']['dmg']

dmg_package 'XCode' do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  owner       node['lyraphase_workstation']['user']
  type        dmg_properties['type']
  accept_eula true
  package_id  dmg_properties['package_id']
end

bash 'Accept XCode build license' do
  user 'root'
  not_if 'xcodebuild -license check'
  code <<~EOEXPECT
    expect -c '
    #!/usr/local/bin/expect -f
    #
    # This Expect script was generated by autoexpect on Wed Sep 25 11:30:49 2013
    # Expect and autoexpect were both written by Don Libes, NIST.
    #
    # Note that autoexpect does not guarantee a working script.  It
    # necessarily has to guess about certain things.  Two reasons a script
    # might fail are:
    #
    # 1) timing - A surprising number of programs (rn, ksh, zsh, telnet,
    # etc.) and devices discard or ignore keystrokes that arrive "too
    # quickly" after prompts.  If you find your new script hanging up at
    # one spot, try adding a short sleep just before the previous send.
    # Setting "force_conservative" to 1 (see below) makes Expect do this
    # automatically - pausing briefly before sending each character.  This
    # pacifies every program I know of.  The -c flag makes the script do
    # this in the first place.  The -C flag allows you to define a
    # character to toggle this mode off and on.

    set force_conservative 0  ;# set to 1 to force conservative mode even if
            ;# script was not run conservatively originally
    if {$force_conservative} {
      set send_slow {1 .1}
      proc send {ignore arg} {
        sleep .1
        exp_send -s -- $arg
      }
    }

    #
    # 2) differing output - Some programs produce different output each time
    # they run.  The "date" command is an obvious example.  Another is
    # ftp, if it produces throughput statistics at the end of a file
    # transfer.  If this causes a problem, delete these patterns or replace
    # them with wildcards.  An alternative is to use the -p flag (for
    # "prompt") which makes Expect only look for the last line of output
    # (i.e., the prompt).  The -P flag allows you to define a character to
    # toggle this mode off and on.
    #
    # Read the man page for more info.
    #
    # -Don


    set timeout -1
    spawn sudo xcodebuild -license
    match_max 100000

    expect {
      -regex {.*Hit the Enter key.*} {
        send -- "\\r"
        exp_continue
      }
      -regex {.*Press '\\''space'\\'' for more, or '\\''q'\\'' to quit.*} {
            set exp_internal 1
            send -- "G"
            exp_continue
          }
      -regex {.*agree, print, cancel.*} {
            set exp_internal 1
            send -- "agree\\r"
      }
    }

    expect eof

    '
  EOEXPECT
end
