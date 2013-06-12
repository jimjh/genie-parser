require 'active_support/core_ext/class/attribute'
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

      # Generated ID.
      ID = 'id'

      # Required keys.
      KEYS = [FORMAT, QUESTION, ANSWER]

      # Stateless markdown renderer.
      class_attribute :markdown
      self.markdown = ::Redcarpet::Markdown.new(::Redcarpet::Render::HTML, MARKDOWN_EXTENSIONS)

      class << self

        # Parses the given text for questions and answers. If the given text
        # does not contain valid YAML or does not contain the format key, raises
        # an {Spirit::Render::RenderError}.
        # @param  [String]  text          embedded yaml
        # @return [Problem] problem
        def parse(text)
          digest = OpenSSL::Digest::SHA256.digest text
          yaml   = YAML.load text
          get_instance(yaml, digest)
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
        def get_instance(hash, digest)
          raise RenderError, "Missing 'format' key in given YAML" unless instantiable? hash
          klass = Spirit::Render.const_get(hash[FORMAT].capitalize)
          raise NameError unless klass < Problem
          klass.new(hash, digest)
        rescue NameError
          raise RenderError, 'Unrecognized format: %p' % hash[FORMAT]
        end

        private

        def instantiable?(hash)
          hash.is_a?(Hash) and hash.has_key?(FORMAT)
        end

      end

      accessor *KEYS
      attr_accessor :nesting, :id
      attr_reader   :digest

      # Creates a new problem from the given YAML.
      # @param [Hash] yaml          parsed yaml object
      # @param [String] digest      SHA-256 hash of yaml text
      # @param [Fixnum] id          integer ID of question
      def initialize(yaml, digest)
        @yaml, @digest, @nesting, @id = yaml, digest, [], 0
        raise RenderError.new('Invalid problem.') unless @yaml[QUESTION].is_a? String
        @yaml[QUESTION] = markdown.render @yaml[QUESTION]
      end

      # @todo TODO should probably show some error message in the preview,
      #   so that the author doesn't have to read the logs.
      def render(locals={})
        raise RenderError.new('Invalid problem.') unless valid?
        super @yaml.merge(locals)
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
