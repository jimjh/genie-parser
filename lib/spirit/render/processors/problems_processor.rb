module Spirit
  module Render
    module Processors

      # Pre-processes problem markup in YAML.
      # Dependent on renderer#problems and renderer#nesting.
      class ProblemsProcessor < Base

        # Paragraphs that start and end with +"""+ are treated as embedded YAML
        # and are parsed for questions/answers.
        REGEX = /^"""$(.*?)^"""$/m

        MARKER = /\A<!-- %%(\d+)%% -->\z/

        attr_reader :problems, :solutions
        delegate :size, :count, :each, :each_with_index, to: :problems
        process  :preprocess, :filter
        process  :block_html, :replace

        def initialize(renderer, *args)
          @renderer  = renderer
          @problems  = []
          @solutions = []
          renderer.problems = self
        end

        # Replaces YAML markup in document with <!-- %%index%% -->
        # @return [String] document
        def filter(document)
          document.gsub(REGEX) { problem $1 }
        end

        def replace(html)
          return html unless is_marker? html
          replace_nesting html, renderer.nesting
          ''
        end

        private

        attr_reader :renderer

        # Update associated problem with nesting information.
        # @return [void]
        def replace_nesting(html, nesting)
          match = html.strip.match MARKER
          prob  = problems[match[1].to_i]
          prob.nesting = nesting.dup
        end

        # @return [Boolean] true iff the given html corresponds to a problem
        #   marker
        def is_marker?(html)
          html.strip =~ MARKER and problems[$1.to_i]
        end

        # If the given text contains valid YAML, returns a marker. Otherwise,
        # returns the original text.
        # @param  [String] text            candidate YAML markup
        # @return [String] text or marker
        def problem(text)
          p = Problem.parse(text, problems.size)
          self.problems  << p
          self.solutions << {digest: p.digest, solution: Marshal.dump(p.answer)}
          Spirit.logger.record :problem, "ID: #{p.id}"
        rescue RenderError
          text
        else "<!-- %%#{p.id}%% -->"
        end

      end

    end
  end
end
