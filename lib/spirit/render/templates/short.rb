# ~*~ encoding: utf-8 ~*~
module Spirit

  module Render

    # Renders short questions marked up in YAML as HTML.
    # @example
    #     {
    #       "format": "short",
    #       "question": "What is the most commonly used word in English?",
    #       "answer": "the"
    #     }
    class Short < Problem

      # Name of template file for rendering short answer questions.
      TEMPLATE = 'short.haml'

      # Checks if the given yaml contains a valid MCQ.
      # @return [Boolean] true iff the yaml contains a valid MCQ.
      def valid?
        super and
          not @yaml[ANSWER].nil?
      end

    end

  end

end

