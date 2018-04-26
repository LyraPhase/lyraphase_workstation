source 'https://rubygems.org'


group :task_runners do
  gem 'thor-foodcritic', '~> 2.0'
  gem 'rake'
end

group :lint do
  gem 'foodcritic', '~> 13.1'
#  gem 'rubocop', '~> 0.34' # Too strict & not pragmatic... Bleh!
end

group :update_fauxhai do
  gem 'fauxhai', '~> 4.0'
end

group :unit do
  gem 'berkshelf',  '~> 7.0'
  gem 'chefspec',   '~> 7.1'
  gem 'chef', '~> 13.8'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.4'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.19'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
#  gem 'ruby_gntp'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard', '~> 2.13'
  gem 'guard-kitchen'
  gem 'guard-foodcritic', '~> 3.0'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'mixlib-versioning'
end
