# ~*~ encoding: utf-8 ~*~
require 'tilt/template'
require 'spirit/constants'

module Spirit

  module Tilt

    # Template adapter for Tilt. This class depends on the tilt gem.
    class Template < ::Tilt::Template

      self.default_mime_type = 'text/html'

      def self.engine_initialized?
        defined? Spirit::Render and defined? Spirit::Render::HTML
      end

      def prepare
        @engine = Spirit::Document.new data, options
        @output = nil
      end

      def evaluate(scope, locals, &block)
        @output ||= @engine.render
      end

      def allows_script?
        false
      end

    end

  end

end
