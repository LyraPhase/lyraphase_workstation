require 'chefspec'
require 'chefspec/berkshelf'

## Gets rid of const redefinition warnings
def create_singleton_struct name, fields
  if Struct::const_defined? name
    Struct.const_get name
  else
    Struct.new name, *fields
  end
end

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.14'
  config.before { stub_const('ENV', ENV.to_hash.merge('SUDO_USER' => 'brubble')) }
  config.filter_run_when_matching :focus
end

at_exit { ChefSpec::Coverage.report! }
