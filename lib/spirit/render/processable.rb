require 'active_support/core_ext/class/attribute'
require 'active_support/concern'

module Spirit
  module Render

    # Provides methods to attach processors.
    module Processable
      extend ActiveSupport::Concern

      included do
        class_attribute :processors,
          instance_reader: false, instance_writer: false
        self.processors = {}          # array of processor classes
        attr_accessor :processors     # array of processor instances
      end

      module ClassMethods

        # @example using a processor
        #     include Processable
        #     use Processor::MathProcessor
        def use(processor)
          processor.events.each do |event|
            processors[event] ||= []
            processors[event] << processor
            define event unless method_defined? event
          end
        end

        def define(event)
          define_method(event) { |*args| invoke_callbacks event, *args }
        end

      end

      def preprocess(document)
        instantiate_processors document
        invoke_callbacks :preprocess, document
      end

      def postprocess(document)
        invoke_callbacks_in_reverse :postprocess, document
      end

      # Instantiate processors. {#processors} becomes a hash from classes to
      # instances.
      def instantiate_processors(document)
        processors = self.class.processors.values.flatten.uniq
        instances  = processors.map { |c| [ c, c.new(self, document) ] }
        self.processors = Hash[instances]
      end
      private :instantiate_processors

      def invoke_callbacks(event, *args)
        processors = processors_for event
        processors.each { |p| args = p.invoke_callbacks_for event, *args }
        args
      end
      private :invoke_callbacks

      def invoke_callbacks_in_reverse(event, *args)
        processors = processors_for(event).reverse
        processors.each { |p| args = p.invoke_callbacks_for event, *args }
        args
      end
      private :invoke_callbacks_in_reverse

      def processors_for(event)
        classes = self.class.processors[event] || []
        classes.map { |c| processors[c] }.compact
      end
      private :processors_for

    end

  end
end
