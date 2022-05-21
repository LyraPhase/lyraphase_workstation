#!/usr/bin/env rake

# http://acrmp.github.com/foodcritic/
require 'foodcritic'

task default: [:knife, :foodcritic, :chefspec]
task test: [:default]

desc 'Run CI default tasks'
task ci: ['default']

FoodCritic::Rake::LintTask.new do |t|
  t.options = {fail_tags: ['correctness'], tags: ['~FC023', '~FC121'], context: true}
end

# http://berkshelf.com/
desc 'Install Berkshelf to local cookbooks path'
task :berks do
  sh %(berks vendor cookbooks)
end

# http://wiki.opscode.com/display/chef/Managing+Cookbooks+With+Knife#ManagingCookbooksWithKnife-test
desc 'Test cookbooks via knife -- NOTE: knife cookbook test was deprecated as of Chef 15.0.29'
task :knife do
  if ENV['TRAVIS_BUILD_DIR']
    cookbook_path = ENV['TRAVIS_BUILD_DIR'] + '/../'
  elsif ENV['GITHUB_WORKSPACE']
    cookbook_path = ENV['GITHUB_WORKSPACE'] + '/../'
  else
    cookbook_path = '.././'
  end
  sh "knife cookbook test -c test/.chef/knife.rb -o #{cookbook_path} -a"
end

# Newer CookStyle target
# Don't use this unless you're a style Gestapo
require 'cookstyle'
require 'rubocop/rake_task'
RuboCop::RakeTask.new do |rubocop|
  rubocop.options << '--display-cop-names'
end

# https://github.com/acrmp/chefspec
desc 'Run ChefSpec Unit Tests'
task :chefspec do
  sh %(rspec --color)
end
