# ~*~ encoding: utf-8 ~*~
require 'spirit/logger'
require 'spirit/constants'
require 'spirit/errors'
require 'spirit/document'
require 'spirit/manifest'

module Spirit
  extend self

  attr_reader :logger

  # Initializes the logger. It takes the same arguments as +Logger::new+.
  # Invoke this at the beginning if you wish {Spirit} to log to another
  # location than +STDOUT+.
  def initialize_logger(output=STDOUT, *args)
    @logger = Logger.new output, *args
  end

  initialize_logger

end
