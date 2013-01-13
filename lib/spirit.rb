# ~*~ encoding: utf-8 ~*~
require 'spirit/logger'
require 'spirit/render'

module Spirit
  extend self

  attr_reader :logger

  # Default options for {Spirit::Render#parse_document}.
  PARSE_DOCUMENT_DEFAULTS = {
    problem: Spirit::Render::Problem
  }

  # Initializes the logger. It takes the same arguments as +Logger::new+.
  # Invoke this at the beginning if you wish {Spirit} to log to another
  # location than +STDOUT+.
  def initialize_logger(output=STDOUT, *args)
    @logger = Logger.new output, *args
  end

  # Parses the given document. It should contain valid Genie Markup Language.
  # Rendered output is returned as a string if +anIO+ is not provided. The
  # output is sanitized with {Spirit::Render::Sanitize}, and should be
  # considered safe for embedding into a HTML page without further escaping or
  # sanitization.
  #
  # The second return value is true if there were no parse errors and false
  # otherwise.
  #
  # @param [Object] source  may be either an instance of +IO+ or an object that responds
  #                         to +to_str+.
  # @param [IO]     anIO    if given, the HTML partial will be written to it.
  #
  # @option opts [Spirit::Render::Problem] :problem
  #   an alternative problem template to use instead of the default template
  #
  # @return [String, Boolean]   if +anIO+ was not provided, and there were no
  #                             errors.
  # @return [Nil,    Boolean]   if +anIO+ was provided, and there were no
  #                             errors
  # @see PARSE_DOCUMENT_DEFAULTS
  # @todo TODO deal with problem template
  # @todo TODO IO
  def parse_document(source, anIO=nil, opts={})
    opts = MARKDOWN_EXTENSIONS.merge opts
    rndr = Render::HTML.new
    mrkd = ::Redcarpet::Markdown.new(rndr, opts)
    return mrkd.render(source), false # TODO
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
