source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'active_storage_base64', '~> 0.1.4'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'brakeman', '~> 4.6', '>= 4.6.1'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.4'
gem 'devise', '~> 4.6', '>= 4.6.2'
gem 'devise_token_auth', '~> 1.1'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'geocoder', '~> 1.5', '>= 1.5.1'
gem 'jbuilder', '~> 2.9', '>= 2.9.1'
gem 'one_signal', '~> 1.2'
gem 'pagy', '~> 3.5', '>= 3.5.1'
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
  gem 'letter_opener', '~> 1.7'
  gem 'rails_best_practices', '~> 1.19', '>= 1.19.4'
  gem 'reek', '~> 5.4'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'rubocop-rails', '~> 2.3', '>= 2.3.2'
end

group :test do
  gem 'faker', '~> 2.1', '>= 2.1.2'
  gem 'rspec-json_expectations', '~> 2.2'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
  gem 'webmock', '~> 3.7', '>= 3.7.2'
end

group :development do
  gem 'annotate', '~> 2.7.5'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails_best_practices-rake_task', '~> 1.0', '>= 1.0.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
