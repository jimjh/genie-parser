# ~*~ encoding: utf-8 ~*~
require 'spirit/render/errors'
require 'spirit/render/sanitize'
require 'spirit/render/templates'
require 'spirit/render/math'
require 'spirit/render/problems'

module Spirit

  module Render

    # HTML Renderer for Genie Markup Language, which is just GitHub Flavored
    # Markdown with Embedded YAML for describing problems. Designed for use
    # with Redcarpet.
    # @see Spirit::Tilt::Template
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML

      cattr_accessor(:sanitizer) { Sanitize.new }
      attr_accessor :headers, :nesting, :problems
      delegate :solutions, to: :problems

      # Paragraphs that only contain images are rendered with {Spirit::Render::Image}.
      IMAGE_REGEX = /\A\s*<img[^<>]+>\s*\z/m

      # Creates a new HTML renderer.
      # @param  [Hash] opts        described in the RedCarpet documentation
      def initialize(opts={})
        @nesting = []
        super RENDERER_CONFIG.dup.merge opts
        @nav, @headers, @img = Navigation.new, Headers.new, 0
      end

      # Pygmentizes code blocks.
      # @param [String] code        code block contents
      # @param [String] marker      name of language
      # @return [String] highlighted code
      def block_code(code, marker)
        Albino.colorize(code, marker || 'text')
      end

      def block_html(html)
        if problems.is_marker? html
          problems.replace_nesting html, nesting
          ''
        else html
        end
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

      # Increases all header levels by one and keeps a navigation bar.
      # @return [String] rendered html
      def header(text, level)
        h = headers.add(text, level+=1)
        @nav.append(text, h.name) if level == 2
        nest h
        h.render
      end

      # Runs a first pass through the document to look for inline math, block
      # math, and block problems.
      # @param [String] document    markdown document
      def preprocess(document)
        @math = Math.new(document)
        document = @math.filter
        self.problems = Problems.new(document)
        document = problems.filter
      end

      # Sanitizes the final document.
      # @param [String]  document    html document
      # @return [String] sanitized document
      def postprocess(document)
        document = Layout.new.render \
          navigation: @nav.render,
          content:  document.force_encoding('utf-8'),
          problems: problems
        document = @math.replace(document)
        sanitizer.clean document
      end

      private

      # @param [Header] h
      def nest(h)
        nesting.pop until nesting.empty? or h.level > nesting.last.level
        nesting << h
      end

      # Prepares a block image. Raises {RenderError} if the given text does not
      # contain a valid image block.
      # @param  [String] text         markdown text
      # @return [String] rendered HTML
      def block_image(text)
        Image.parse(text).render(index: @img += 1)
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
