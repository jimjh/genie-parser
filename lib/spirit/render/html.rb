# ~*~ encoding: utf-8 ~*~
require 'spirit/render/errors'
require 'spirit/render/sanitize'
require 'spirit/render/templates'
require 'spirit/render/math'

module Spirit

  module Render

    # HTML Renderer for Genie Markup Language, which is just GitHub Flavored
    # Markdown with Embedded YAML for describing problems. Designed for use
    # with Redcarpet.
    # @see Spirit::Tilt::Template
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML

      @sanitize = Sanitize.new
      class << self; attr_reader :sanitize end

      # Paragraphs that start and end with +"""+ are treated as embedded YAML
      # and are parsed for questions/answers.
      PROBLEM_REGEX = /^"""$(.*?)^"""$/m

      # Paragraphs that only contain images are rendered with {Spirit::Render::Image}.
      IMAGE_REGEX = /\A\s*<img[^<>]+>\s*\z/m

      # Renderer configuration options.
      CONFIGURATION = {
        hard_wrap:          true,
        no_styles:          true,
      }

      # Creates a new HTML renderer.
      # @param  [Hash] options        described in the RedCarpet documentation.
      # @option options [Array] :problems container to collect parsed problems;
      #   if provided, then solutions will not be persisted.
      def initialize(options={})
        @persist_solutions = !options.key?(:problems)
        @problems          = options.delete(:problems) || []
        @problems_html     = []
        super CONFIGURATION.merge options
        @nav, @headers, @img = Navigation.new, Headers.new, 0
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
        # TODO
        #case type
        #when 'demo', 'test'
        #  executable id: id, raw: code, colored: highlighted
        #else highlighted end
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
        html, name = h(text, level += 1)
        @nav.append(text, name) if level == 2
        html
      end

      # Runs a first pass through the document to look for inline math, block
      # math, and block problems.
      # @param [String] document    markdown document
      def preprocess(document)
        @math = Math.new(document)
        @math.filter.gsub(PROBLEM_REGEX) { problem $1 }
      end

      # Sanitizes the final document.
      # @param [String]  document    html document
      # @return [String] sanitized document
      def postprocess(document)
        document = Layout.new.render \
          navigation: @nav.render,
          content: document.force_encoding('utf-8'),
          problems: @problems_html
        document = @math.replace(document)
        HTML.sanitize.clean document
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

      # Prepares a problem form. Returns +yaml+ if the given text does not
      # contain valid yaml markup for a problem, and an empty string otherwise.
      # @param [String] yaml            YAML markup
      # @return [String] rendered HTML or empty string
      def problem(yaml)
        problem = Problem.parse(yaml, @problems.size)
        problem.save! if @persist_solutions
        @problems_html << problem.render
        @problems << { digest: problem.digest, solution: Marshal.dump(problem.answer) }
        Spirit.logger.record :problem, "ID: #{problem.id}"
      rescue RenderError
        yaml
      else ''
      end

      # Prepares a block image. Raises {RenderError} if the given text does not
      # contain a valid image block.
      # @param  [String] text         markdown text
      # @return [String] rendered HTML
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
      # @return [String] rendered html
      def p(text)
        '<p>' + text + '</p>'
      end

    end

  end
end
