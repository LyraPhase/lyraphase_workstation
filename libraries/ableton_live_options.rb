class AbletonLiveOptions
  module Helpers
    require 'nokogiri'
    require 'open-uri'

    def ableton_live_option_valid?(option)
      return false if option.nil? || ! option.kind_of?(String)
      if ABLETON_LIVE_VALID_OPTIONS.include?(option) || ! ABLETON_LIVE_VALID_OPTIONS.index{|el| el == option.split('=').first }.nil?
        return true
      else
        Chef::Log.warn "Invalid Ableton Live Option detected! Refusing to write this one to Options.txt!"
        Chef::Log.warn "Invalid Option: #{option}"
        return false
      end
    end

    def self.ableton_live_get_valid_options
      # Return the static set of known options
      Chef::Log.debug("All valid options: #{ALL_KNOWN_OPTIONS}")
      return ALL_KNOWN_OPTIONS
    end

    # All known options as of 12/12/2021
    ALL_KNOWN_OPTIONS = ["AbsoluteMouseMode", "AutoAdjustMacroMappingRange",
                        "DontCombineAPCs", "EnableArmOnSelection",
                        "EnableMapToSiblings", "_EnsureKeyMessagesForPlugins",
                        "_LegacyWaveformDrawing", "MaxFpsMac",
                        "NoAutoArming", "NoVstStartupScan",
                        "_PluginAutoPopulateThreshold", "_RelaxFileManagerSearch",
                        "ReWireChannels", "ReWireMasterOff",
                        "ShowDeviceSlots", "StrictDelayCompensation",
                        "ThinningAggressiveness"] unless const_defined?(:ALL_KNOWN_OPTIONS)
    # Fold them into our list of valid options
    ABLETON_LIVE_VALID_OPTIONS = self.ableton_live_get_valid_options unless const_defined?(:ABLETON_LIVE_VALID_OPTIONS)
  end
end

Chef::Recipe.send(:include, AbletonLiveOptions::Helpers)
