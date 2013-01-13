# ~*~ encoding: utf-8 ~*~
require 'tilt/template'
require 'spirit/constants'

module Spirit

  module Tilt

    # Template adapter for Tilt
    class Template < ::Tilt::Template

      self.default_mime_type = 'text/html'

      def self.engine_initialized?
        defined? Spirit::Render
      end

      def prepare
        @output = nil
      end

      def evaluate(scope, locals, &block)
        output, _ = Spirit.parse_document data, nil, options
        @output ||= output
      end

      def allows_script?
        false
      end

    end

  end

end
