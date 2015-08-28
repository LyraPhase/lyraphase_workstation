#
# Author:: James Cuzella (<james.cuzella@lyraphase.com>)
# Cookbook Name:: lyraphase_workstation
# Libraries:: pkg_package
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

class Chef
  class Recipe
    class PkgPackage
      require 'chef/mixin/shell_out'
      extend Chef::Mixin::ShellOut
      def self.pkg_installed?(package_id)
        if self.shell_out("pkgutil --pkgs='#{package_id}'").exitstatus == 0
          Chef::Log.info "Already installed; to upgrade, try \"sudo pkgutil --forget '#{package_id}'\""
          true
        else
          false
        end
      end
    end
  end
end
