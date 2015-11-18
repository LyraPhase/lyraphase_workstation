#
# Author:: James Cuzella (<james.cuzella@lyraphase.com>)
# Cookbook Name:: lyraphase_workstation
# Libraries:: avid_bugcheck
#
# Copyright 2015, James Cuzella
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class AVIDBugCheck
  require 'chef/mixin/shell_out'
  extend Chef::Mixin::ShellOut

  def self.is_avid_coreaudio_installed?
    if ::File.directory?("/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin") || self.shell_out("pkgutil --pkgs='com.avid.avid.AvidCoreAudioPlugIn'").exitstatus == 0
      Chef::Log.warn "AVID CoreAudio is installed! You may encounter problems with Native Instruments hardware and AVID drivers!"
      Chef::Log.warn "NI knows about this issue, for more information see: http://www.native-instruments.com/en/support/knowledge-base/show/3163/mac-os-x-10.10-yosemite-compatibility-news/"
      true
    elsif self.shell_out("pkgutil --pkgs | grep -iq com.avid").exitstatus == 0
      Chef::Log.warn "AVID packages were detected! You may encounter problems with Native Instruments hardware and AVID drivers!"
      Chef::Log.warn "NI hardware has known issues with some AVID software! For more information see: http://www.native-instruments.com/en/support/knowledge-base/show/3163/mac-os-x-10.10-yosemite-compatibility-news/"
      true
    else
      false
    end
  end
end
