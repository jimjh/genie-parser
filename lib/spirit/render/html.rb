require 'active_support/core_ext/module/delegation'

require 'spirit/render/errors'
require 'spirit/render/templates'
require 'spirit/render/processable'
require 'spirit/render/processors'

module Spirit
  module Render

    # HTML Renderer for Genie Markup Language, which is just GitHub Flavored
    # Markdown with Embedded YAML for describing problems. Designed for use
    # with Redcarpet.
    # @see Spirit::Tilt::Template
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML
      include Processable

      delegate :solutions, to: :problems
      attr_accessor :navigation, :problems, :nesting

      use Processors::SanitizeProcessor
      use Processors::MathProcessor
      use Processors::LayoutProcessor
      use Processors::ProblemsProcessor
      use Processors::PygmentsProcessor
      use Processors::BlockImageProcessor
      use Processors::HeadersProcessor

      # Creates a new HTML renderer.
      # @param  [Hash] opts        described in the RedCarpet documentation
      def initialize(opts={})
        super RENDERER_CONFIG.merge opts
      end

    end

  end
end
