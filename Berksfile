#source 'http://api.berkshelf.com'
source "https://supermarket.chef.io"

group :integration do
  cookbook "minitest-handler"
end

cookbook 'sprout-base', '~> 0.1', :github => 'pivotal-sprout/sprout-base'
cookbook 'osx', '~> 0.1.0', :github => 'pivotal-sprout/osx'

cookbook 'plist', '~> 0.9', :github => 'trinitronx/chef-plist', rel: 'vendor/cookbooks/plist', :branch => 'add-chefspec-matchers'

cookbook 'homebrew', '>= 1.13.0'

metadata
