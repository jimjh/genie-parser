# ~*~ encoding: utf-8 ~*~
require 'spirit/render'

module Spirit

  # Document written in Genie Markup Language.
  # @todo TODO clean?
  class Document

    attr_accessor :data, :engine

    # Creates a new document from the given source. It should contain valid
    # markdown + embedded YAML.
    # @param [IO, #to_str] source
    # @param [Hash]        opts         options for {::Redcarpet}
    def initialize(source, opts={})
      opts = MARKDOWN_EXTENSIONS.merge opts
      rndr = Render::HTML.new
      @engine = ::Redcarpet::Markdown.new(rndr, opts)
      @data   = (IO === source) ? source.read : source.to_str
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
    # @return [Fixnum]  if +anIO+ was provided, returns the number of bytes
    #                   written.
    # @raise [Spirit::Error] if a fatal error is encountered.
    def render(anIO=nil)
      output = engine.render(data)
      return IO.write output unless IO.nil?
      output
    end

  end

end
