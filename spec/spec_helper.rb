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
