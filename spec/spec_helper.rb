require 'chefspec'
require 'chefspec/berkshelf'


RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.8.2' # FIXME: system ruby and fauxhai don't play nice
                            # since there is no 10.9.2.json file yet. We
                            # should submit a PR to fauxhai to fix this
  config.before { stub_const('ENV', ENV.to_hash.merge('SUDO_USER' => 'brubble')) }
end