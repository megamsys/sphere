source 'http://rubygems.org'

# Rails
gem 'rails', '~> 4.1.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'

# Templating engine
gem 'slim-rails'

# The Thin webserver (since Puma has strange output logging)
gem 'thin'

# Use autoprefixer to add browser prefixes to css rules
gem 'autoprefixer-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
# Coffeescript is not actually used in this project, but some gems require it, and we get a warning when deploying if we do not include explicitly.
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library, by default get them from cdn
gem 'jquery-rails'
gem 'jquery-rails-cdn'
gem 'jquery-ui-rails'
gem 'jquery-ui-rails-cdn'

# Use Modernizr to detect support for new features
gem 'modernizr-rails'

# Use the gistyle gem for the Garber Irish Javascript loading implementation
gem 'gistyle'

# Color picker
gem 'jquery-minicolors-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Rails-i18n for standard rails locales
gem 'rails-i18n'

# Devise for authentication. Gems are locked on minor versions, because we use custom Devise functionality and views.
gem 'devise', '~> 3.2.4'
gem 'devise_invitable', '~> 1.3.5'
gem 'devise-i18n', '~> 0.10.3'
gem 'devise-i18n-views', '~> 0.2.8'

# Use CanCanCan for access control / authorisation
gem 'cancancan'

# Use I18n alchemy gem for easy date parsing and localization in forms
gem 'i18n_alchemy'

# Responders gem for nice and easy responses after CRUD actions
gem 'responders'

# Nested forms helpers
gem 'nested_form', github: 'ramonsnir/nested_form'

# Image uploads
gem 'mini_magick'
gem 'carrierwave'

# Image galery
gem 'magnific-popup-rails'

# ActiveRecord Import for multi INSERTs at once
gem 'activerecord-import'

# Active model tableless for using tableless models in a nested form
gem 'activerecord-tableless'

# Logging of changes
gem 'audited-activerecord'

# Ancestry gem for ActiveRecord tree helpers
gem 'ancestry'

# Route functions in JavaScript
gem 'js-routes'

# Javascript MomentJS for date formatting and alterations
gem 'momentjs-rails'

# search in selects
gem 'select2-rails'

# PG_Search for easy text search and global searching
gem 'pg_search', '~> 0.7.3' # Locked on minor version, because we use custom search functionality (see lib/core_ext/pg_search.rb).

# Easy pagination (and unfortunately unefficient due to unnecessary queries)
gem 'kaminari'

# Websockets so we could create push notifications
# Include websocket only on Linux, since it does not work on Windows. Waiting for fix of issue #186.
platform :ruby do
  # Use threadsocket-rails and sub_protocol branches due to bug with standalone mode with version 0.7.0 of the official gem.
  # Monitor issue #231 and switch back to normal gem after the changes are merged in.
  gem 'websocket-rails', github: 'moaa/websocket-rails', branch: 'threadsocket-rails'
  gem 'websocket-rails-js', github: 'websocket-rails/websocket-rails-js', branch: 'sub_protocols'
end

# Organisation of the seeds
gem 'seedbank'

# Holidays gem to determine the dates of holidays.
gem 'holidays', github: 'kreintjes/holidays' # Custom gem to add support for identifier keys and kings day holiday

# Translate numbers to words (and ordinal forms).
gem 'numbers_and_words', github: 'kreintjes/numbers_and_words' # Custom gem to add ordinal support for dutch locale.

# Attribute normalizer to normalize/cleanup attribute values (for instance change blanks to nils)
gem 'attribute_normalizer'

# Ice cube gem for easy recurrence rules
gem 'ice_cube'

# export vCard files
gem 'vcard'

# Repeat (filter) get fields as hidden fields
gem 'hash_to_hidden_fields'

# Validator for timeliness of dates
gem 'validates_timeliness'

# Validator for valid email address
gem 'valid_email'

# Make ActiveRecord objects deep clonable (dup) including associations
gem 'deep_cloneable'

# Factory girl to generate data for tests (this is a replacement for fixtures)
gem 'factory_girl_rails'

# The forgery fake data generator (useful for testing)
gem 'forgery'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# Symbolizes Active Record attributes and validates them against a list
gem 'symbolize'

# Tagging solution
gem 'acts-as-taggable-on'

# Alert us on application exception, by e-mail and push notification (Flyblown)
gem 'exception_notification'
gem 'ruby-notify-my-android'

# Tools for formatting and validating IBAN numbers
gem 'iban-tools'

# Easy (manual) positioning of ActiveRecord objects
gem 'acts_as_list'

group :development do
  # Disable messages about assets in development
  gem 'quiet_assets'

  # Pry for easy debugging
  gem 'pry-rails'

  # Bullet for warnings about potential query optimalisations
  gem 'bullet'

  # Spring gem for application pre-loading leading to faster Rails commands
  gem 'spring'

  # Semver for easy versioning
  gem 'semver'

  # Capistrano for easy deployment
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'

  # Rubocop for code style checking of Ruby files (possibly in combination with SublimeLinter)
  gem 'rubocop', require: false

  # SCSS-Lint for code syntax and style checking of SCSS files (possibly in combination with SublimeLinter)
  gem 'scss-lint', require: false
end
