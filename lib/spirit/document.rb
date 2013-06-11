# ~*~ encoding: utf-8 ~*~
require 'spirit/constants'
require 'spirit/errors'
require 'spirit/render'

module Spirit

  # Document written in Genie Markup Language.
  class Document

    attr_reader :data, :engine, :rndr
    delegate :solutions, to: :rndr

    # Creates a new document from the given source. It should contain valid
    # markdown + embedded YAML.
    # @param [#read, #to_str] source
    # @param [Hash] opts         options for {::Redcarpet}
    def initialize(source, opts={})
      opts = MARKDOWN_EXTENSIONS.merge opts
      @rndr   = Render::HTML.new
      @engine = ::Redcarpet::Markdown.new(rndr, opts)
      @data   = case
                when source.respond_to?(:to_str) then source.to_str
                when source.respond_to?(:read) then source.read
                else nil end
    end

    # Rendered output is returned as a string if +anIO+ is not provided. The
    # output is sanitized with {Spirit::Render::Sanitize}, and should be
    # considered safe for embedding into a HTML page without further escaping or
    # sanitization.
    #
    # @param [IO] anIO  if given, the HTML partial will be written to it.
    # @return [String]  if +anIO+ was not provided, returns the HTML string.
    # @return [Fixnum]  if +anIO+ was provided, returns the number of bytes
    #                   written.
    # @raise [Spirit::Error] if a fatal error is encountered.
    def render(anIO=nil)
      output = engine.render(data)
      return anIO.write(output) unless anIO.nil?
      output
    end

  end

end
