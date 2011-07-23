source 'http://rubygems.org'

gem 'rails', :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable'

gem 'unicorn'

# Asset template engines
gem 'json'
gem 'sass'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'
gem 'pjax-rails' # just for the controller stuff for now

# Everything else
gem 'sunspot_rails', :git => 'git://github.com/nz/sunspot'

group :development, :test do
  gem 'foreman'
  gem 'growl'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'rspec-rails'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end