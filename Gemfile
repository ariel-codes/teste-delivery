# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# minimalist framework for building rack applications
gem "rack-app", "~> 7.7"
# A small and fast Ruby web server
gem "thin", "~> 1.8"
# Coercion and validation for data structures
gem "dry-schema", "~> 1.6"
# Ruby driver for MongoDB
gem "mongo", "~> 2.14"
# A Ruby gem to load environment variables from `.env`.
gem "dotenv", "~> 2.7"

group :development do
  # Ruby Style Guide, with linter & automatic code fixer
  gem "standard"
end

group :test do
  # Behaviour Driven Development for Ruby.
  gem "rspec", "~> 3.10"
  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem "webmock", "~> 3.12", require: "webmock/rspec"
end

group :test, :development do
  # A runtime developer console and IRB alternative with powerful introspection capabilities.
  gem "pry"
end
