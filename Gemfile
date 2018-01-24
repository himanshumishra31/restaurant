source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
ruby                               '2.4.1'
gem 'rails',                       '~> 5.1.4'
gem 'bcrypt',                      '~> 3.1.7'
gem 'bootstrap-sass',              '~> 3.3.7'
gem 'coffee-rails',                '~> 4.2'
gem 'figaro',                      '1.1.1'
gem 'pg',                          '~> 0.18'
gem 'jbuilder',                    '~> 2.5'
gem 'jquery-rails',                '~> 4.3.1'
gem 'jquery-ui-rails',             '~>6.0.1'
gem "nested_form",                 '0.3.2'
gem 'nested_form_fields',          '0.8.2'
gem "paperclip",                   "5.0.0"
gem 'puma',                        '~> 3.7'
gem 'sass-rails',                  '~> 5.0'
gem 'stripe',                      '3.9.1'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier',                    '>= 1.3.0'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen',                    '>= 3.0.5', '< 3.2'
  gem 'web-console',               '>= 3.3.0'
  gem 'letter_opener',             '1.4.1'
  gem 'bullet',                    '5.7.2'
end

