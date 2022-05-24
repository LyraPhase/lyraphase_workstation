# -*- coding: utf-8 -*-
# frozen_string_literal: true

#
# Author:: James Cuzella (@trinitronx)
# Cookbook:: lyraphase_workstation
# Libraries:: avid_bugcheck
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2015-2021, James Cuzella
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

# rubocop:disable Metrics/LineLength
class AVIDBugCheck
  require 'chef/mixin/shell_out'
  extend Chef::Mixin::ShellOut

  def self.avid_coreaudio_installed?
    avid_coreaudio_present =
      ::File.directory?('/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin') ||
      shell_out("pkgutil --pkgs='com.avid.avid.AvidCoreAudioPlugIn'").exitstatus == 0
    if avid_coreaudio_present
      Chef::Log.warn('AVID CoreAudio is installed! You may encounter problems with Native Instruments hardware and AVID drivers!')
      Chef::Log.warn('NI knows about this issue, for more information see: http://www.native-instruments.com/en/support/knowledge-base/show/3163/mac-os-x-10.10-yosemite-compatibility-news/')
      true
    elsif shell_out('pkgutil --pkgs | grep -iq com.avid').exitstatus == 0
      Chef::Log.warn('AVID packages were detected! You may encounter problems with Native Instruments hardware and AVID drivers!')
      Chef::Log.warn('NI hardware has known issues with some AVID software! For more information see: http://www.native-instruments.com/en/support/knowledge-base/show/3163/mac-os-x-10.10-yosemite-compatibility-news/')
      true
    else
      false
    end
  end
end
# rubocop:enable Metrics/LineLength
