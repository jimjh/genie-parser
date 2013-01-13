# ~*~ encoding: utf-8 ~*~
require 'spirit/render/errors'
require 'spirit/render/sanitize'
require 'spirit/render/templates'

module Spirit

  module Render

    # HTML Renderer for Genie Markup Language, which is just GitHub Flavored
    # Markdown with Embedded YAML for describing problems.
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML

      @sanitize = Sanitize.new
      class << self; attr_reader :sanitize end

      # Paragraphs that start and end with braces are treated as embedded YAML
      # and are parsed for questions/answers.
      PROBLEM_REGEX = /\A\s*{.+\z/m

      # Paragraphs that only contain images are rendered with {Spirit::Render::Image}.
      IMAGE_REGEX = /\A\s*<img[^<>]+>\s*\z/m

      # Renderer configuration options.
      CONFIGURATION = {
        hard_wrap:          true,
        no_styles:          true,
      }

      # Creates a new HTML renderer.
      # @param [Hash] options        described in the RedCarpet documentation.
      def initialize(options = {})
        super CONFIGURATION.merge options
        @nav, @headers = Navigation.new, Headers.new
        @prob, @img = 0, 0 # indices for Problem #, Figure #
      end

      # Pygmentizes code blocks.
      # @param [String] code        code block contents
      # @param [String] marker      name of language, for syntax highlighting
      # @return [String] highlighted code
      def block_code(code, marker)
        #language, type, id = (marker || 'text').split ':'
        #highlighted = Albino.colorize code, language
        language, _, _ = (marker || 'text').split ':'
        Albino.colorize code, language
        #case type
        #when 'demo', 'test'
        #  executable id: id, raw: code, colored: highlighted
        #else highlighted end
      end

      # Detects problem blocks and image blocks.
      # @param [String] text      paragraph text
      def paragraph(text)
        case text
        when PROBLEM_REGEX then problem(text)
        when IMAGE_REGEX then block_image(text)
        else p(text) end
      rescue Error => e # fall back to paragraph
        logger.warn e.message
        p(text)
      end

      # Increases all header levels by one and keeps a navigation bar.
      def header(text, level)
        html, name = h(text, level += 1)
        @nav.append(text, name) if level == 2
        html
      end

      # Sanitizes the final document.
      # @param [String] document    html document
      # @return [String] sanitized document
      def postprocess(document)
        HTML.sanitize.clean(@nav.render + document.force_encoding('utf-8'))
      end

      private

      # Prepares an executable code block.
      # @option opts [String] id        author-supplied ID
      # @option opts [String] raw       code to execute
      # @option opts [String] colored   syntax highlighted code
      # @return [String]
      #def executable(opts)
      #  opts[:colored] + @exe.render(Object.new, id: opts[:id], raw: opts[:raw])
      #end

      # Prepares a problem form. Raises {RenderError} or {ParseError} if the
      # given text does not contain valid json markup for a problem.
      # @param [String] json            JSON markup
      # @return [String] rendered HTML
      def problem(json)
        b = '\\' # unescape backslashes
        problem = Problem.parse(HTMLEntities.new.decode(json).gsub(b, b * 4))
        problem.save! and problem.render(index: @prob += 1)
      end

      # Prepares a block image. Raises {RenderError} or {ParseError} if the
      # given text does not contain a valid image block.
      def block_image(text)
        Image.parse(text).render(index: @img += 1)
      end

      # Wraps the given text with header tags.
      # @return [String] rendered HTML
      # @return [String] anchor name
      def h(text, level)
        header = @headers.add(text, level)
        return header.render, header.name
      end

      # Wraps the given text with paragraph tags.
      # @param [String] text            paragraph text
      # @return [String] wrapped text
      def p(text)
        '<p>' + text + '</p>'
      end

    end

  end
end
