require 'active_support/core_ext/class/attribute'
require 'spirit/constants'
module Spirit

  module Render

    # Base class for all templates. Class classes should override the
    # +template+ class attribute.
    class Template

      class_attribute :template

      # Renders the given problem using {#view}.
      # @param [Hash] locals         local variables to pass to the template
      def render(locals={})
        view.render self, locals
      end

      private

      # Retrieves the +view+ singleton. If it is nil, initializes it from
      # +self.template+. Note that this is reloaded with every refresh so I can
      # edit the templates without restarting.
      # @todo TODO optimize by reusing the HAML engine
      # @return [Haml::Engine] haml engine
      def view
        return @view unless @view.nil?
        file = File.join VIEWS, self.template
        @view = Haml::Engine.new File.read(file), HAML_CONFIG
      end

    end

  end

end
