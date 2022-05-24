# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Libraries:: config_file_line
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2015-2022 James Cuzella
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
# A basic wrapper class to avoid ChefSpec ruby_block testing problems:
#  1. Only implements minimum used methods for parent Chef::Util::FileEdit class to avoid unintended side-effects
#  2. Separating this code out of ruby_block lets us test & exercise the code using a Mock Object and test fixture config file
class LyraPhase
  class ConfigFile < Chef::Util::FileEdit
    def initialize(filename)
      super(filename)
    end

    def insert_line_if_no_match(pattern, line)
      super(pattern, line)
    end

    def write_file
      super()
    end

    def unwritten_changes?
      super()
    end

    def file_edited?
      super()
    end
  end
end

class LyraPhase
  module Helpers
    # Separate the code from the recipe so:
    #  - ChefSpec tests can call the helper method
    #  - Recipe calls same helper method
    #  - Code follows D.R.Y.
    #  - Ensure that tested behavior always matches Recipe's behavior
    def add_streamlocalbindunlink_to_sshd_config
      file = LyraPhase::ConfigFile.new('/etc/ssh/sshd_config')
      file.insert_line_if_no_match(/.*Remove stale forwarding sockets.*/, '# Remove stale forwarding sockets (https://wiki.gnupg.org/AgentForwarding)')
      file.insert_line_if_no_match(/.*StreamLocalBindUnlink.*/, 'StreamLocalBindUnlink yes')
      file.write_file
    end
  end
end

Chef::Recipe.send(:include, LyraPhase::Helpers)
Chef::Resource::RubyBlock.send(:include, LyraPhase::Helpers)
