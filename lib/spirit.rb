# ~*~ encoding: utf-8 ~*~
require 'spirit/logger'
require 'spirit/constants'
require 'spirit/document'

module Spirit
  extend self

  attr_reader :logger

  # Initializes the logger. It takes the same arguments as +Logger::new+.
  # Invoke this at the beginning if you wish {Spirit} to log to another
  # location than +STDOUT+.
  def initialize_logger(output=STDOUT, *args)
    @logger = Logger.new output, *args
  end

  # Parses the given manifest. It should contain a valid lesson manifest.
  # @param [Object] source  may be either an instance of +IO+ or an object that responds
  #                         to +to_str+.
  # @return [Hash] manifest
  def parse_manifest(source)
    # TODO
  end

  initialize_logger

end
