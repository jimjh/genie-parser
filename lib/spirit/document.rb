# ~*~ encoding: utf-8 ~*~
require 'spirit/render'

module Spirit

  # Document written in Genie Markup Language.
  # @todo TODO deal with problem template
  # @todo TODO IO
  # @todo TODO clean?
  class Document

    attr_accessor :data, :engine

    # Creates a new document from the given source. It should contain valid
    # Genie Markup Language.
    # @param [IO, #to_str] source
    # @param [Hash]        opts         options for {::Redcarpet}
    def initialize(source, opts={})
      opts = MARKDOWN_EXTENSIONS.merge opts
      rndr = Render::HTML.new
      @engine = ::Redcarpet::Markdown.new(rndr, opts)
      @data   = source # TODO
    end

    # @return [Boolean] true iff if was a clean parse with no errors.
    def clean?
      # TODO
    end

    # Rendered output is returned as a string if +anIO+ is not provided. The
    # output is sanitized with {Spirit::Render::Sanitize}, and should be
    # considered safe for embedding into a HTML page without further escaping or
    # sanitization.
    #
    # @param [IO] anIO  if given, the HTML partial will be written to it.
    # @return [String]  if +anIO+ was not provided
    # @return [IO]      if +anIO+ was provided
    # @raise [Spirit::Error] if a fatal error is encountered.
    def render(anIO=nil)
      return engine.render(data)
    end

  end

end
