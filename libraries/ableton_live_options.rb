class AbletonLiveOptions
  module Helpers
    require 'nokogiri'
    require 'open-uri'

    def self.ableton_live_option_valid?(option)
      if ! ABLETON_LIVE_VALID_OPTIONS.include?(option)
        Chef::Log.warn "Possibly invalid Ableton Live Option detected! You may encounter problems!"
        Chef::Log.warn "Possibly invalid Option: #{option}"
        return false
      else
        return true
      end
    end

    def self.ableton_live_get_valid_options
      ableton_options_help_page = open('https://help.ableton.com/hc/en-us/articles/209772865-Options-txt-file-for-Live').read

      nokogiri_obj = Nokogiri::HTML(ableton_options_help_page)

      ableton_possible_options = nokogiri_obj.xpath("//article/*/div[@class='body-text']/h3")

      valid_options = Array.new()

      ableton_possible_options.each do |possible_option|
        valid_options.push( possible_option.text.gsub!(/\A"|"\Z/, '') ) if possible_option.text =~ /^".*?"$/
      end
      # Return the union of both sets of options
      return valid_options | ALL_KNOWN_OPTIONS
    end

    # All known options as of 12/19/2016
    ALL_KNOWN_OPTIONS = ["AbsoluteMouseMode", "AutoAdjustMacroMappingRange",
                        "DontCombineAPCs", "EnableArmOnSelection",
                        "EnableMapToSiblings", "EnsureKeyMessagesForPlugins",
                        "NoAutoArming", "NoVstStartupScan",
                        "_PluginAutoPopulateThreshold", "ReWireChannels",
                        "ReWireMasterOff", "ShowDeviceSlots",
                        "ThinningAggressiveness"] unless const_defined?(:ALL_KNOWN_OPTIONS)
    # If Ableton doc is ever updated with new options, then fold them into our list
    ABLETON_LIVE_VALID_OPTIONS = self.ableton_live_get_valid_options unless const_defined?(:ABLETON_LIVE_VALID_OPTIONS)
  end
end

Chef::Recipe.send(:include, AbletonLiveOptions::Helpers)
