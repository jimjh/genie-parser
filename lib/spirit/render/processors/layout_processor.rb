module Spirit
  module Render
    module Processors

      # Post-processes a layout in HAML.
      class LayoutProcessor < Base

        TEMPLATE = File.join Spirit::VIEWS, 'layout.haml'

        attr_accessor :engine, :renderer
        process :postprocess, :render

        def initialize(renderer, *args)
          template  = File.read TEMPLATE, escape_html: true, format: :html5
          @engine   = Haml::Engine.new template
          @renderer = renderer
        end

        def render(document)
          engine.render renderer,
            content: document.force_encoding('utf-8')
        end

      end

    end
  end
end
