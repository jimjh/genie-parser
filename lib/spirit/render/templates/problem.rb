# ~*~ encoding: utf-8 ~*~
require 'spirit/constants'
module Spirit

  module Render

    # Renders a single problem. This class doesn't do anything useful; use the
    # child classes (e.g. {Spirit::Render::Multi}) instead. Child classes should
    # override {#valid?}.
    class Problem < Template

      # Required key in YAML markup. Value indicates type of problem.
      FORMAT = 'format'

      # Required key in YAML markup. Value contains question body.
      QUESTION = 'question'

      # Required key in YAML markup. Value contains answers.
      ANSWER = 'answer'

      # Optional key in YAML markup. Value contains problem ID.
      ID = 'id'

      # Required keys.
      KEYS = [FORMAT, QUESTION, ANSWER]

      # Stateless markdown renderer.
      MARKDOWN = ::Redcarpet::Markdown.new(::Redcarpet::Render::HTML, MARKDOWN_EXTENSIONS)

      class << self

        # Parses the given text for questions and answers. If the given text
        # does not contain valid YAML or does not contain the format key, raises
        # an {Spirit::Render::RenderError}.
        # @param  [String]  text          embedded yaml
        # @return [Problem] problem
        def parse(text)
          yaml = YAML.load text
          get_instance(yaml)
        rescue ::Psych::SyntaxError => e
          raise RenderError, e.message
        end

        # Dynamically creates accessor methods for YAML values.
        # @example
        #   accessor :id
        def accessor(*args)
          args.each { |arg| define_method(arg) { @yaml[arg] } }
        end

        # @return [Problem] problem
        def get_instance(yaml)
          raise RenderError, "Missing 'format' key in given YAML" unless instantiable? yaml
          klass = Spirit::Render.const_get(yaml[FORMAT].capitalize)
          raise NameError unless klass < Problem
          klass.new(yaml)
        rescue NameError
          raise RenderError, 'Unrecognized format: %p' % yaml[FORMAT]
        end

        private

        def instantiable?(yaml)
          yaml.is_a?(Hash) and yaml.has_key?(FORMAT)
        end

      end

      accessor ID, *KEYS

      # Creates a new problem from the given YAML.
      # @param [Hash] yaml          parsed yaml object
      def initialize(yaml)
        @yaml = yaml
        @yaml[ID] ||= SecureRandom.uuid
        @yaml[QUESTION] = MARKDOWN.render @yaml[QUESTION]
      end

      # @todo TODO should probably show some error message in the preview,
      #   so that the author doesn't have to read the logs.
      def render(locals={})
        raise RenderError.new('Invalid problem.') unless valid?
        yaml = @yaml.merge(locals)
        super yaml
      end

      # Saves the answer to a file on disk.
      # @todo TODO should probably show some error message in the preview,
      #   so that the author doesn't have to read the logs.
      def save!
        raise RenderError.new('Invalid problem.') unless valid?
        solution = File.join(Spirit::SOLUTION_DIR, id + Spirit::SOLUTION_EXT)
        File.open(solution, 'wb+') { |file| Marshal.dump answer, file }
      end

      # Retrieves the answer from the given YAML object in a serializable form.
      # @see #serializable
      # @return [String, Numeric, TrueClass, FalseClass] answer
      def answer
        serialize @yaml[ANSWER]
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

      # Checks that all required {KEYS} exist in the YAML, and that the
      # question is given as a string.
      # @return [Boolean] true iff the parsed yaml contains a valid problem.
      def valid?
        KEYS.all? { |key| @yaml.has_key? key } and question.is_a? String
      end

    end

  end

end
