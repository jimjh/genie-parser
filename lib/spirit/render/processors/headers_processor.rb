module Spirit
  module Render
    module Processors

      # In-charge of headers, navigation bar, and nesting.
      # Depends on renderer#navigation and renderer#nesting
      class HeadersProcessor < Base

        process :header, :header

        def initialize(renderer, *args)
          renderer.nesting = @nesting = []
          renderer.navigation = @navigation = Navigation.new
          @headers = Headers.new
        end

        # Increases all header levels by one and keeps a navigation bar.
        # @return [String] rendered html
        def header(text, level)
          h = headers.add(text, level += 1)
          navigation.append(text, h.name) if level == 2
          nest h
          h.render
        end

        private

        attr_accessor :headers, :navigation, :nesting

        # Maintains the +nesting+ array.
        # @param [Header] h
        def nest(h)
          nesting.pop until nesting.empty? or h.level > nesting.last.level
          nesting << h
        end

      end

    end
  end
end
