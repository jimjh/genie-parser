# ~*~ encoding: utf-8 ~*~
require 'active_support/core_ext/string/inflections'

module Spirit

  module Render

    # Keeps track of headers within the same document. It's responsible for
    # assigning unique names that can be used in the anchors.
    class Headers

      def initialize
        @headers = {}
      end

      # Adds a new header to the set.
      # @return [Header] header
      def add(text, level=1)
        name = text.parameterize
        if @headers.include? name
          name += '-%d' % (@headers[name] += 1)
        else @headers[name] = 0 end
        Header.new(text, level, name)
      end

    end

    # Renders a header (e.g. +h1+, +h2+, ...) with anchors.
    class Header < Template

      # Name of template file for rendering headers.
      TEMPLATE = 'header.haml'

      attr_reader :name, :text, :level

      # Creates a new header.
      # @param [String] text          header text
      # @param [Fixnum] level         1 to 6
      # @param [String] name          anchor name
      def initialize(text, level, name)
        @text, @level, @name = text, level, name
      end

      def render(locals={})
        super locals.merge(text: @text, level: @level, name: @name)
      end

    end

  end

end
