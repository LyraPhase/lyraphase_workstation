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

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.8.2' # FIXME: system ruby and fauxhai don't play nice
                            # since there is no 10.9.2.json file yet. We
                            # should submit a PR to fauxhai to fix this
  config.before { stub_const('ENV', ENV.to_hash.merge('SUDO_USER' => 'brubble')) }
end