# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: ableton_live_options
# Site:: https://www.ableton.com/
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

class AbletonLiveOptions
  module Helpers
    require 'nokogiri'
    require 'open-uri'

    def ableton_live_option_valid?(option)
      return false if option.nil? || !option.is_a?(String)

      option_valid =
        ABLETON_LIVE_VALID_OPTIONS.include?(option) ||
        !ABLETON_LIVE_VALID_OPTIONS.index { |el| el == option.split('=').first }.nil?
      return true if option_valid

      Chef::Log.warn 'Invalid Ableton Live Option detected! Refusing to write this one to Options.txt!'
      Chef::Log.warn "Invalid Option: #{option}"
      false
    end

    def self.ableton_live_get_valid_options
      # Return the static set of known options
      Chef::Log.debug("All valid options: #{ALL_KNOWN_OPTIONS}")
      ALL_KNOWN_OPTIONS
    end

    # All known options as of 12/12/2021
    unless const_defined?(:ALL_KNOWN_OPTIONS)
      ALL_KNOWN_OPTIONS = ['AbsoluteMouseMode', 'AutoAdjustMacroMappingRange',
                           'DontCombineAPCs', 'EnableArmOnSelection',
                           'EnableMapToSiblings', '_EnsureKeyMessagesForPlugins',
                           '_LegacyWaveformDrawing', 'MaxFpsMac',
                           'NoAutoArming', 'NoVstStartupScan',
                           '_PluginAutoPopulateThreshold', '_RelaxFileManagerSearch',
                           'ReWireChannels', 'ReWireMasterOff',
                           'ShowDeviceSlots', 'StrictDelayCompensation',
                           'ThinningAggressiveness'].freeze
    end
    # Fold them into our list of valid options
    ABLETON_LIVE_VALID_OPTIONS = ableton_live_get_valid_options unless const_defined?(:ABLETON_LIVE_VALID_OPTIONS)
  end
end

Chef::Recipe.include AbletonLiveOptions::Helpers
