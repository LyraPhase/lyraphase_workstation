#!/usr/bin/env rake

# http://acrmp.github.com/foodcritic/
require 'foodcritic'

task :default => [:knife, :foodcritic, :chefspec]
task :test => [:default]

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['correctness'], :tags => ['~FC023'] }
end

# http://berkshelf.com/
desc "Install Berkshelf to local cookbooks path"
task :berks do
  sh %{berks install --path cookbooks}
end

# http://wiki.opscode.com/display/chef/Managing+Cookbooks+With+Knife#ManagingCookbooksWithKnife-test
desc "Test cookbooks via knife"
task :knife do
  cookbook_path = ENV['TRAVIS_BUILD_DIR'] ? ENV['TRAVIS_BUILD_DIR'] + '/../' : '.././'
  sh "knife cookbook test -c test/.chef/knife.rb -o #{cookbook_path} -a"
end

# https://github.com/acrmp/chefspec
desc "Run ChefSpec Unit Tests"
task :chefspec do
  sh %{rspec --color}
end
