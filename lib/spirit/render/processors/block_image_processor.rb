module Spirit
  module Render
    module Processors

      class BlockImageProcessor < Base

        process :paragraph, :paragraph

        # Paragraphs that only contain images are rendered with
        # {Spirit::Render::Image}.
        IMAGE_REGEX = /\A\s*<img[^<>]+>\s*\z/m

        def initialize(*args)
          @image = 0
        end

        # Detects block images and renders them as such.
        # @return [String] rendered html
        def paragraph(text)
          case text
          when IMAGE_REGEX then block_image(text)
          else p(text) end
        rescue RenderError => e # fall back to paragraph
          Spirit.logger.warn e.message
          p(text)
        end

        private

        # Prepares a block image. Raises {RenderError} if the given text does
        # not contain a valid image block.
        # @param  [String] text           markdown text
        # @return [String] rendered HTML
        def block_image(text)
          Image.parse(text).render(index: @image += 1)
        end

        # Wraps the given text with paragraph tags.
        # @param [String] text            paragraph text
        # @return [String] rendered html
        def p(text)
          '<p>' + text + '</p>'
        end

      end

    end
  end
end
