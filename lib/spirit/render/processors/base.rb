require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'
require 'spirit/constants'

module Spirit
  module Render
    module Processors

      class Base

        class_attribute :hooks

        def self.inherited(subclass)
          subclass.hooks  = {}
        end

        def self.process(event, callback)
          hooks[event] ||= []
          hooks[event] << callback
        end

        def self.events
          hooks.keys
        end

        def initialize(*args)
        end

        def invoke_callbacks_for(event, *args)
          hooks[event].each do |h|
            args = public_send(h, *args)
          end
          args
        end

      end

    end
  end
end
