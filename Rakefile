#!/usr/bin/env rake

# http://acrmp.github.com/foodcritic/
require 'foodcritic'

task :default => [:foodcritic, :knife, :chefspec]

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['correctness'] }
end

# http://berkshelf.com/
desc "Install Berkshelf to local cookbooks path"
task :berks do
  sh %{berks install --path cookbooks}
end

# http://wiki.opscode.com/display/chef/Managing+Cookbooks+With+Knife#ManagingCookbooksWithKnife-test
desc "Test cookbooks via knife"
task :knife do
  sh %{knife cookbook test -o cookbooks -a}
end

# https://github.com/acrmp/chefspec
desc "Run ChefSpec Unit Tests"
task :chefspec do
  sh %{rspec --color}
end
