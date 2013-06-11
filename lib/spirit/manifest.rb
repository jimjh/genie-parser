require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'yaml'

module Spirit

  # Manifest described in YAML. Values in this hash should not be trusted,
  # since they are provided by the user.
  class Manifest < Hash

    # Expected types.
    TYPES = {
      verify: { 'bin' => 'string', 'arg_prefix' => 'string' },
      title: 'string',
      description: 'string',
      categories: %w[string array],
      static_paths: %w[string array]
    }.freeze

    # Creates a new manifest from the given source.
    def initialize(hash)
      super nil
      hash ||= {}
      bad_file(hash.class) unless hash.is_a? Hash
      merge! hash.symbolize_keys
      check_types
    end

    # Load configuration from given string.
    # @param [String] source
    # @return [Manifest] manifest
    def self.load(source)
      new ::YAML.load source
    rescue ::Psych::SyntaxError => e
      raise ManifestError, 'Unexpected syntax error - ' + e.message
    end

    # Load configuration from given yaml file.
    # @param [String] path
    # @return [Manifest] manifest
    def self.load_file(path)
      File.open(path, 'r:utf-8') { |f| new ::YAML.load f.read }
    rescue ::Psych::SyntaxError => e
      raise ManifestError, 'Unexpected syntax error - ' + e.message
    end

    private_class_method :new

    private

    # Checks that the given hash has the valid types for each value, if they
    # exist.
    # @raise [ManifestError] if a bad type is encountered.
    def check_types(key='root', expected=TYPES, actual=self, opts={})
      bad_type(key, expected, actual, opts) unless actual.is_a? expected.class
      case actual
      when Hash then actual.each { |k, v| check_types(k, expected[k], v) }
      when Enumerable then actual.each { |v| check_types(key, expected.first, v, enum: true) }
      end
    end

    def bad_file(type)
      raise ManifestError, <<-eos.squish
        The manifest file should contain a dictionary, but a #{type.name} was
        found.
      eos
    end

    def bad_type(key, expected, actual, opts={})
      verb = opts[:enum] ? 'contain' : 'be'
      raise ManifestError, <<-eos.squish
        The #{key} option in the manifest file should #{verb} a #{expected.class.name}
        instead of a #{actual.class.name}.
      eos
    end

  end

end
