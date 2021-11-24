source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'bootsnap', '>= 1.4.2', require: false

gem 'rails', '~> 6.1.4'

gem 'puma'
gem 'sass-rails'
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
gem 'tzinfo-data'
gem 'icalendar'
gem 'pg'
gem 'redis'
gem 'hiredis'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
