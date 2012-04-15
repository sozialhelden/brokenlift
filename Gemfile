source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :default do
  gem 'pry-rails'
  gem 'mysql2', '0.3.11'
  gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
  gem 'aasm'
  gem 'acts_as_api'
  gem 'kaminari'
  gem 'heroku'
  gem 'responders'
  gem 'inherited_resources'
  gem 'fastercsv'
  gem 'whenever'
  gem 'unicorn'
  gem 'nokogiri'
  gem 'delayed_job_active_record'
end

group :test, :development do
  gem 'sqlite3'
  gem 'rspec-rails'
end

group :production do
  gem 'therubyracer'
  gem 'uglifier'
  gem 'execjs'
end

group :test do
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'capybara'
end

# Gems used only for assets and not required
# in production environments by default.

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

group :deployment do
  # Deploy with Capistrano
  gem 'capistrano'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

gem "devise"
