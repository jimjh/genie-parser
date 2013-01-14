# ~*~ encoding: utf-8 ~*~
module Spirit

  module Render

    # Base class for all templates. Child classes should provide a +TEMPLATE+
    # string constant that contains the path to the relevant HAML file.
    class Template

      # Renders the given problem using {#view}.
      # @param [Hash] locals         local variables to pass to the template
      def render(locals={})
        view.render Object.new, locals
      end

      private

      # Retrieves the +view+ singleton. If it is nil, initializes it from
      # +self.class.TEMPLATE+. Note that this is reloaded with every refresh so
      # I can edit the templates without refreshing.
      # @return [Haml::Engine] haml engine
      def view
        return @view unless @view.nil?
        file = File.join Spirit::VIEWS, self.class::TEMPLATE
        @view = Haml::Engine.new(File.read file, escape_html: true, format: :html5)
      end

    end

  end

end
