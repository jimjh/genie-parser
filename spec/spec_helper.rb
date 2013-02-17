# ~*~ encoding: utf-8 ~*~
require 'rubygems'
require 'bundler/setup'
require 'rspec'

begin Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems."
  exit e.status_code
end

require 'factory_girl'
require 'faker'
require 'securerandom'

module Test
  ROOT = Pathname.new File.dirname(__FILE__)
end

$:.unshift Test::ROOT + '..' + 'lib'
require 'spirit'
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
end
