# ~*~ encoding: utf-8 ~*~
module Spirit

  module Render

    # Renders multiple choice questions marked up in YAML as HTML.
    # @example
    #
    #     """
    #     format: multi
    #     question: How tall is Mount Everest?
    #     answer: A
    #     options:
    #       A: 452 inches
    #       B: 8.85 kilometers
    #     """
    class Multi < Problem

      # Required key in YAML markup. Associated value should be a dictionary of
      # label -> choices.
      OPTIONS = 'options'

      # Name of template file for rendering multiple choice questions.
      self.template = 'multi.haml'

      # Checks if the given yaml contains a valid MCQ.
      # @return [Boolean] true iff the yaml contains a valid MCQ.
      def valid?
        super and
          @yaml[ANSWER].is_a? String and
          @yaml.has_key?(OPTIONS) and
          @yaml[OPTIONS].is_a? Hash
      end

    end

  end

end
