require "bundler/setup"
Bundler.require :default

Dotenv.load ".env.development"

require "./app"

run DeliveryApp
