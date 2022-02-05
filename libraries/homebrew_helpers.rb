# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Recipe:: homebrew_helpers
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯  2013-2022 James Cuzella
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
class LyraPhase
  module Helpers
    # rubocop:disable Style/ClassCheck, Style/MultilineBlockChain, Naming/PredicateName
    def has_formula_named?(arr, formula_name)
      arr.flat_map { |elem|
        elem.include?(formula_name) || (elem.kind_of?(Hash) && elem.keys.any? { |k| elem[k].include?(formula_name) })
      }.any? { |elem| elem == true }
    end
    # rubocop:enable Style/ClassCheck, Style/MultilineBlockChain, Naming/PredicateName
  end
end

Chef::Recipe.send(:include, LyraPhase::Helpers)
