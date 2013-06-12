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
require 'tempfile'

module Test
  ROOT = Pathname.new __dir__
end

$:.unshift Test::ROOT + '..' + 'lib'
Dir[Test::ROOT + 'shared' + '**' + '*.rb'].each { |f| require f }

require 'spirit'

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  config.before :suite do
    FactoryGirl.find_definitions
    Spirit.reset_logger '/dev/null'
  end

end
