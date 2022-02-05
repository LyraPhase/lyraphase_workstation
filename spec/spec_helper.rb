# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Spec:: spec_helper
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
require 'chefspec'
require 'chefspec/berkshelf'
require 'spec_shared_contexts'

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.14'

  config.alias_example_group_to :describe_recipe, type: :recipe
  config.alias_example_group_to :describe_helpers, type: :helpers
  config.alias_example_group_to :describe_resource, type: :resource

  config.before { stub_const('ENV', ENV.to_hash.merge('SUDO_USER' => 'brubble')) }
  config.filter_run_when_matching :focus
end

at_exit { ChefSpec::Coverage.report! }
