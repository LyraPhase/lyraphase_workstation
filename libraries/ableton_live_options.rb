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
      mtime = File.mtime(__FILE__).utc
      # mtime = Time.at(1495134812).utc # testing
      Chef::Log.info("libraries/ableton_live_options.rb mtime: #{mtime}")
      begin
        ableton_options_help_page = open('https://help.ableton.com/hc/en-us/articles/209772865-Options-txt-file-for-Live', 'If-Modified-Since' => mtime.rfc2822 ) do |f|
          Chef::Log.debug(f.base_uri)
          Chef::Log.debug(f.content_type)
          Chef::Log.debug(f.charset)
          Chef::Log.debug(f.content_encoding)
          Chef::Log.debug(f.last_modified)
        end
      rescue OpenURI::HTTPError => error
        response = error.io
        Chef::Log.warn("AbletonLiveOptions#ableton_live_get_valid_options: Got HTTP #{response.status} from Ableton page https://help.ableton.com/hc/en-us/articles/209772865-Options-txt-file-for-Live when trying to get updated list of valid Options.txt entries")
        # => ["503", "Service Unavailable"]
        Chef::Log.debug("AbletonLiveOptions#ableton_live_get_valid_options: Got error message: #{response.string}")
        Chef::Log.warn("AbletonLiveOptions#ableton_live_get_valid_options: Falling back to cached list of valid options.  This is safe to ignore.")
        # => <!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html DIR=\"LTR\">\n<head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"initial-scale=1\">...
        raise unless error.message =~ /^(304|404)/
      end

      nokogiri_obj = Nokogiri::HTML(ableton_options_help_page)

      ableton_possible_options = nokogiri_obj.xpath("//article/*/div[@class='body-text']/h3")

      valid_options = Array.new()

      ableton_possible_options.each do |possible_option|
        valid_options.push( possible_option.text.gsub!(/\A"|"\Z/, '') ) if possible_option.text =~ /^".*?"$/
      end
      # Return the union of both sets of options
      Chef::Log.debug("ableton_possible_options: #{ableton_possible_options}")
      Chef::Log.debug("All valid options: #{valid_options | ALL_KNOWN_OPTIONS}")
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
