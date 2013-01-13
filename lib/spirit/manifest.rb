# ~*~ encoding: utf-8 ~*~
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

module Spirit

  # Manifest described in YAML. Values in this hash should not be trusted,
  # since they are provided by the user.
  class Manifest < Hash

    # Expected types.
    TYPES = {
      verify: { 'bin' => 'string', 'arg_prefix' => 'string' },
      title: 'string',
      description: 'string',
      categories: %w(string),
      static_paths: %w(string)
    }

    # Creates a new configuration hash from the given source.
    def initialize(hash)
      super nil
      merge! hash.symbolize_keys
      check_types
    end

    # Load configuration from given string.
    # @param [String] source
    def self.load(source)
      new YAML.load source
    end

    # Load configuration from given yaml file.
    # @param [String] path
    def self.load_file(path)
      new YAML.load_file path
    end

    private_class_method :new

    private

    # Checks that the given hash has the valid types for each value.
    # @raise [ManifestError] if a bad type is encountered.
    def check_types(key='root', expected=TYPES, actual=self)
      bad_type(key, expected, actual) unless actual.is_a? expected.class
      case actual
      when Hash then actual.each { |k, v| check_types(k, expected[k], v) }
      when Enumerable then actual.each { |v| check_types(key, expected.first, v) }
      end
    end

    def bad_type(key, expected, actual)
      raise ManifestError.new <<-eos.squish
        The #{key} option in the manifest file should be a #{expected.class.name}
        instead of a #{actual.class.name}.
      eos
    end

  end

end
