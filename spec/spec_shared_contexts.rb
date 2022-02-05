# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook:: lyraphase_workstation
# Spec:: spec_shared_contexts
# Site:: https://github.com/LyraPhase/lyraphase_workstation/
#
# License:: GPL-3.0+
# Copyright:: (C) © 🄯 2016-2022 James Cuzella
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

## Helper Methods
## Gets rid of const redefinition warnings
def create_singleton_struct(name, fields)
  if Struct.const_defined? name
    Struct.const_get name
  else
    Struct.new name, *fields
  end
end

def stringify_keys(hash)
  hash.each_with_object({}) do |(k, v), base|
    v = stringify_keys(v) if v.is_a? Hash
    base[k.to_s] = v
    base
  end
end

# Note: Chef >= 15 no longer runs Ohai :Passwd plugin
#       Now you must manually enable this plugin because this cookbook depends on it
# Add to client.rb:
#    ohai.optional_plugins = [ :Passwd ]

## RSpec Shared Contexts
# D.R.Y. ChefSpec tests to mock Ohai /etc/passwd data
# Source: https://github.com/sous-chefs/ark/blob/bcdf8108a3754a5c9c1257f9535dd1e6554bc998/spec/spec_helper.rb
# References:
#   - https://www.chef.io/blog/watch-writing-elegant-tests
#   - https://www.rubydoc.info/github/rspec/rspec-core/RSpec%2FCore%2FConfiguration:alias_example_group_to
#   - https://github.com/chefspec/fauxhai#fauxhai-ng
#   - https://github.com/chef/chef/issues/8888
#   - https://docs.chef.io/ohai/#optional-plugins
#   - https://stackoverflow.com/a/57953198/645491
RSpec.shared_context 'recipe tests', type: :recipe do
  # Individual spec Example Groups can override this to inject node attributes
  let(:chefspec_options) do
    {
      default_attributes: {},
      normal_attributes: {},
      automatic_attributes: {},
    }
  end

  let(:chef_run) do
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::ServerRunner
    klass.new(chefspec_options) do |node|
      node.normal.merge!(node_attributes)
    end.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  def lyraphase_workstation_user
    create_singleton_struct 'EtcPasswd', [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
    Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
  end

  # Global ChefSpec attributes for all Example Groups
  def node_attributes
    attributes = {
      'platform': 'mac_os_x',
      'version': '10.15',
      'etc': {
        'passwd': {
          'brubble': lyraphase_workstation_user,
        },
      },
      'sprout': {
        'home': '/Users/brubble',
        'user': 'brubble',
      },
      'lyraphase_workstation': {
        'user': 'brubble',
        'home': '/Users/brubble',
      },
    }
    stringify_keys(attributes)
  end

  def cookbook_recipe_names
    described_recipe.split('::', 2)
  end

  def cookbook_name
    cookbook_recipe_names.first
  end

  def recipe_name
    cookbook_recipe_names.last
  end

  def default_cookbook_attribute(attribute_name)
    node[cookbook_name][attribute_name]
  end
end

RSpec.shared_context 'helpers tests', type: :helpers do
  include described_class

  let(:new_resource) { OpenStruct.new(resource_properties) }

  def resource_properties
    @resource_properties || {}
  end

  def with_resource_properties(properties)
    @resource_properties = properties
  end

  let(:node) do
    Fauxhai.mock { |node| node.merge!(node_attributes) }.data
  end

  def node_attributes
    stringify_keys(@node_attributes || {})
  end

  def with_node_attributes(attributes)
    @node_attributes = attributes
  end
end

RSpec.shared_context 'resource tests', type: :resource do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(node_attributes.merge(step_into)).converge(example_recipe)
  end

  let(:example_recipe) do
    raise %(
Please specify the name of the test recipe that executes your recipe:
    let(:example_recipe) do
      "lyraphase_workstation::example_recipe"
    end
)
  end

  let(:node) { chef_run.node }

  def node_attributes
    {}
  end

  let(:step_into) do
    { step_into: [cookbook_name] }
  end

  def cookbook_recipe_names
    described_recipe.split('::', 2)
  end

  def cookbook_name
    cookbook_recipe_names.first
  end

  def recipe_name
    cookbook_recipe_names.last
  end
end

shared_context 'Chef 14.x no EtcPasswd' do
  let(:chef_run) do
    ## Note: We run chef_run.converge here to raise exceptions for RSpec to check
    ChefSpec::SoloRunner.new(node_attributes).converge(described_recipe)
  end
  let(:node) { chef_run.node }

  let(:chef_log_warnings) do
    ["Chef >= 14.x removed node['etc']['passwd'] Ohai attributes that sprout cookbooks depend on!",
     'Please manually enable Ohai Passwd plugin, or populate cookbook attributes!',
     'References: ',
     '            https://docs.chef.io/ohai/#optional-plugins',
     '            https://github.com/chef/chef/issues/8888',
     '            https://stackoverflow.com/a/57953198/645491',
    ]
  end

  let(:chef_log_fatal_msgs) do
    ['node[\'etc\'][\'passwd\'] Ohai attributes are nil!']
  end

  def node_attributes
    {}
  end

  let(:fake_chef_version) do
    fake_chef_version = double('Chef::VERSION')
    allow(fake_chef_version).to receive(:to_s).and_return('14.0.190')
    fake_chef_version
  end

  before(:each) do
    chef_log_warnings.each do |warning_msg|
      allow(Chef::Log).to receive(:warn).with(warning_msg).and_return(nil)
    end
    chef_log_fatal_msgs.each do |fatal_msg|
      allow(Chef::Log).to receive(:fatal).with(fatal_msg).and_return(nil)
    end
    stub_const('::Chef::VERSION', fake_chef_version)
  end
end
