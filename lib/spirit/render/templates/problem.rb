# ~*~ encoding: utf-8 ~*~
module Spirit

  module Render

    # Renders a single problem. This class doesn't do anything useful; use the
    # child classes (e.g. {Spirit::Render::Multi}) instead. Child classes should
    # override {#valid?}.
    class Problem < Template

      # Required key in JSON markup. Value indicates type of problem.
      FORMAT = 'format'

      # Required key in JSON markup. Value contains question body.
      QUESTION = 'question'

      # Required key in JSON markup. Value contains answers.
      ANSWER = 'answer'

      # Optional key in JSON markup. Value contains problem ID.
      ID = 'id'

      # Required keys.
      KEYS = [FORMAT, QUESTION, ANSWER]

      class << self

        # Parses the given text for questions and answers. If the given text
        # does not contain valid JSON or does not contain the format key, raises
        # an {Spirit::Render::RenderError}.
        # @param [String] text          markdown text
        def parse(text)
          json = JSON.parse text
          if json.is_a?(Hash) and json.has_key?(FORMAT)
            get_instance(json)
          else raise RenderError, "Expected a JSON object containing the #{FORMAT} key."
          end
        rescue JSON::JSONError => e
          raise RenderError, e.message
        end

        # Dynamically creates accessor methods for JSON values.
        # @example
        #   accessor :id
        def accessor(*args)
          args.each { |arg| define_method(arg) { @json[arg] } }
        end

        # @return [Problem] problem
        def get_instance(json)
          klass = Spirit::Render.const_get(json[FORMAT].capitalize)
          raise NameError.new unless klass < Problem
          klass.new(json)
        rescue NameError
          raise RenderError, 'Unrecognized format: %p' % json[FORMAT]
        end

      end

      accessor ID, *KEYS

      # Creates a new problem from the given JSON.
      # @param [Hash] json          parsed JSON object
      def initialize(json)
        @json = json
        @json[ID] ||= SecureRandom.uuid
      end

      # @todo TODO should probably show some error message in the preview,
      #   so that the author doesn't have to read the logs.
      def render(locals={})
        raise RenderError.new('Invalid problem.') unless valid?
        json = @json.merge(locals)
        super json
      end

      # Saves the answer to a file on disk.
      # @todo TODO should probably show some error message in the preview,
      #   so that the author doesn't have to read the logs.
      def save!
        raise RenderError.new('Invalid problem.') unless valid?
        solution = File.join(Spirit::SOLUTION_DIR, id + Spirit::SOLUTION_EXT)
        File.open(solution, 'wb+') { |file| Marshal.dump answer, file }
      end

      # Retrieves the answer from the given JSON object in a serializable form.
      # @see #serializable
      # @return [String, Numeric, TrueClass, FalseClass] answer
      def answer
        serialize @json[ANSWER]
      end

      private

      # If +obj+ is one of String, Numeric, +true+, or +false+, the it's
      # returned. Otherwise, +to_s+ is invoked on the object and returned.
      # @return [String, Numeric, TrueClass, FalseClass] answer
      def serialize(obj)
        case obj
        when String, Numeric, TrueClass, FalseClass then obj
        else obj.to_s end
      end

      # Checks that all required {KEYS} exist in the JSON, and that the
      # question is given as a string.
      # @return [Boolean] true iff the parsed json contains a valid problem.
      def valid?
        KEYS.all? { |key| @json.has_key? key } and question.is_a? String
      end

    end

  end

end
