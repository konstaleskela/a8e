source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.12'

# Use sqlite3 as the database for Active Record (in development)
gem 'sqlite3'
# use postgresql in production
group :production do
  gem 'pg', require: false
end

# Use SCSS for stylesheets
#gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

#gem 'compass-rails' # you need this or you get an err
#gem 'zurb-foundation', '~> 4.0.0'
gem 'foundation-rails', '~> 5.4.0'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'simple_form'
gem 'reference_number'
gem 'sidekiq'
gem 'sinatra', :require => nil

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger', require: false
  gem 'pry-nav'
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
