#source 'http://api.berkshelf.com'
source "https://supermarket.chef.io"

group :integration do
  cookbook "minitest-handler"
end

cookbook 'sprout-base', '~> 0.1', :github => 'trinitronx/sprout-base', :branch => 'fix-CHEF-33-deprecation-chef-v17'
cookbook 'osx', '~> 0.1.0', :github => 'trinitronx/osx', :branch => 'fix-CHEF-33-deprecation-chef-v17'

cookbook 'plist', '~> 0.9.4', :github => 'trinitronx/chef-plist', rel: 'vendor/cookbooks/plist', :branch => 'fix-CHEF-33-deprecation-chef-v17'
#OLD = :branch => 'add-chefspec-matchers'

cookbook 'homebrew', '>= 4.0.0'

metadata
