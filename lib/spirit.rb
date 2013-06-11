require 'spirit/version'
require 'spirit/logger'
require 'spirit/constants'
require 'spirit/errors'
require 'spirit/document'
require 'spirit/manifest'

module Spirit

  mattr_accessor :logger
  @@logger = Logger.new '/dev/null'

  # Invoke with args for {Logger} to enable logging.
  def self.reset_logger(io=STDOUT, *args)
    self.logger = Logger.new(io, *args)
    logger.formatter = Logger::Formatter.new
    logger.info "Spirit v#{VERSION}"
  end

end
