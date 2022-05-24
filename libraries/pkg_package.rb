# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Author:: James Cuzella (<james.cuzella@lyraphase.com>)
# Cookbook:: lyraphase_workstation
# Libraries:: pkg_package
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

class Chef
  class Recipe
    class PkgPackage
      require 'chef/mixin/shell_out'
      extend Chef::Mixin::ShellOut
      def self.pkg_installed?(package_id)
        if shell_out("pkgutil --pkgs='#{package_id}'").exitstatus == 0
          Chef::Log.info "Already installed; to upgrade, try \"sudo pkgutil --forget '#{package_id}'\""
          true
        else
          false
        end
      end
    end
  end
end
