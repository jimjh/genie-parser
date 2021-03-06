module Spirit

  module Render

    # Keeps track of document sections and renders a navigation bar.
    class Navigation < Template

      delegate :size, :count, to: :@sections

      # HAML template for navigation bar
      self.template = 'nav.haml'

      # Creates a new navigation bar.
      def initialize
        @sections = {}
      end

      # Adds a new section.
      # @param [String] heading      section heading
      # @param [String] name         anchor name
      # @return [void]
      def append(heading, name)
        @sections[name] = heading
      end

      # Renders the navigation bar in HTML.
      def render(locals={})
        super locals.merge(sections: @sections)
      end

    end

  end

end
