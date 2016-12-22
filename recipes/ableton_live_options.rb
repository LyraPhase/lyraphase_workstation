#
# Cookbook Name:: lyraphase_workstation
# Recipe:: ableton_live
# Site:: https://www.ableton.com/
#
# Copyright (C) 2013-2016 James Cuzella
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
raise "Attribute: lyraphase_workstation is not defined well (should be Hash)" unless Hash === node['lyraphase_workstation']
raise "Attribute: ableton_live is not defined well (should be Hash)" unless Hash === node['lyraphase_workstation']['ableton_live']
raise "Attribute: ableton_live.options is not defined well (should be Array)" unless Array === node['lyraphase_workstation']['ableton_live']['options']

# Ableton preferences path where Options.txt lives
ableton_preferences_path = "#{node['lyraphase_workstation']['home']}/Library/Preferences/Ableton"
# Options to enable
ableton_live_options = node['lyraphase_workstation']['ableton_live']['options'].reject{|opt| ! ableton_live_option_valid?(opt)}
# Installed ableton versions sorted by version number
ableton_live_versions = Dir.glob("#{ableton_preferences_path}/*").map {
                          |dir| File.basename(dir).gsub!(/^Live /, '')
                        }.sort_by{|v| Gem::Version.new(v)}

attribute_managed_versions = node['lyraphase_workstation']['ableton_live']['managed_versions']
ableton_live_managed_versions = Array.new()

# Handle versions to manage passed in via attributes
# If nil or empty, simply use latest version
# If passed an Array, convert all elements to string and remove empty or nil elements
# If passed a String that is not empty or 'all', create an array of 1 element from this string
# If passed the special String 'all', manage all detected Ableton versions
if attribute_managed_versions.nil? || attribute_managed_versions.empty?
  ableton_live_managed_versions = ableton_live_managed_versions.push( ableton_live_versions.last )
elsif attribute_managed_versions.kind_of?(Array)
  ableton_live_managed_versions = attribute_managed_versions
elsif attribute_managed_versions.kind_of?(String) && attribute_managed_versions != 'all' && !attribute_managed_versions.empty?
  ableton_live_managed_versions = ableton_live_managed_versions.push( attribute_managed_versions )
elsif attribute_managed_versions == 'all'
  ableton_live_managed_versions = ableton_live_versions
end

ableton_live_managed_versions = ableton_live_managed_versions.map {|el| el.to_s}.reject {|el| el == '' || el.nil? }

Chef::Log.info("Ableton Live Managed Versions: #{ableton_live_managed_versions}")

unless ableton_live_managed_versions.nil? || ableton_live_managed_versions.empty?
  ableton_live_managed_versions.each do |ableton_live_version|
    # Ensure directory exists if Ableton has never been started yet (installed first time)
    directory "#{ableton_preferences_path}/Live #{ableton_live_version}" do
      owner node['lyraphase_workstation']['user']
      group 'staff'
      mode '0755'
      action :create
    end

    template "#{ableton_preferences_path}/Live #{ableton_live_version}/Options.txt" do
      source 'Ableton.Options.txt.erb'
      owner  node['lyraphase_workstation']['user']
      group 'staff'
      mode '0644'
      variables({
        :ableton_live_options => ableton_live_options
      })
      action :create
    end
  end
end