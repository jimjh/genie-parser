# ~*~ encoding: utf-8 ~*~
module Spirit

  module Render

    # Renders short questions marked up in JSON as HTML.
    # @example
    #     {
    #       "format": "short",
    #       "question": "What is the most commonly used word in English?",
    #       "answer": "the"
    #     }
    class Short < Problem

      # Name of template file for rendering short answer questions.
      TEMPLATE = 'short.haml'

      # Checks if the given json contains a valid MCQ.
      # @return [Boolean] true iff the json contains a valid MCQ.
      def valid?
        super and
          not @json[ANSWER].nil?
      end

    end

  end

end

