module Spirit
  module Render

    # Pre-processes problem markup in YAML.
    class Problems

      # Paragraphs that start and end with +"""+ are treated as embedded YAML
      # and are parsed for questions/answers.
      REGEX = /^"""$(.*?)^"""$/m

      MARKER = /<!-- %%(\d+)%% -->/

      attr_reader :problems, :solutions
      delegate :size, :count, :each, :each_with_index, to: :problems

      def initialize(document)
        @problems  = []
        @document  = document
        @solutions = []
      end

      # Replaces YAML markup in document with <!-- %%index%% -->
      # @return [String] document
      def preprocess
        document.gsub(REGEX) { problem $1 }
      end

      def block_html(html, nesting)
        return html unless is_marker? html
        replace_nesting html, nesting
        ''
      end

      private

      attr_reader :document

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
        self.solutions << { digest: p.digest, solution: Marshal.dump(p.answer) }
        Spirit.logger.record :problem, "ID: #{p.id}"
      rescue RenderError
        text
      else "<!-- %%#{p.id}%% -->"
      end

    end

  end
end
