source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.0'

gem 'rails', '~> 8.0.0'
gem 'pg'
gem 'puma', '>= 6.0'
gem 'bootsnap', require: false

# Asset pipeline
gem 'propshaft'
gem 'importmap-rails'
gem 'dartsass-rails'
gem 'bootstrap', '~> 5.3'

# Solid Stack
gem 'solid_queue'
gem 'solid_cache'
gem 'solid_cable'

# Turbolinks (we will eventually replace with Turbo)
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.14'
gem 'redis', '~> 4.0'
gem 'active_storage_validations'
gem 'kaminari'
gem 'selectize-rails'
gem 'devise', '>= 5.0'
gem 'cancancan'
gem 'responders'
gem 'administrate'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
