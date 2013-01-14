# ~*~ encoding: utf-8 ~*~
require 'nokogiri'

module Spirit

  module Render

    # Renders a block image with a figure number.
    class Image < Template

      # <img ...>
      IMAGE_TAG = 'img'

      # Name of template file for rendering block images
      TEMPLATE = 'img.haml'

      class << self

        # Parses the given text for a block image.
        def parse(text)
          Image.new text
        end

      end

      # Creates a new image.
      def initialize(html)
        @html = html
        parse_or_raise
      end

      def render(locals={})
        super locals.merge(img: @html, caption: @node['alt'])
      end

      private

      # Parses the given HTML, or raise {RenderError} if it is invalid.
      def parse_or_raise
        frag = Nokogiri::HTML::DocumentFragment.parse(@html)
        if 1 == frag.children.count and
          node = frag.children.first and
          node.is_a? Nokogiri::XML::Element and
          node.name == IMAGE_TAG
          @node = node
        else raise RenderError, 'Not really a block image.'
        end
      end

    end

  end

end
