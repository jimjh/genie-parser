require 'pygments'
module Spirit
  module Render
    module Processors

      class PygmentsProcessor < Base

        process :block_code, :highlight_code

        # Pygmentizes code blocks.
        # @param [String] code        code block contents
        # @param [String] marker      name of language
        # @return [String] highlighted code
        def highlight_code(code, marker)
          Pygments.highlight(code, lexer: marker || 'text')
        end

      end

    end
  end
end
