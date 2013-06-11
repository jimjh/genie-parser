module Spirit
  module Render

    # Pre-processes math markup in latex.
    # Adapted from
    # http://www.math.union.edu/~dpvc/transfer/mathjax/mathjax-editing.js
    class Math

      # Pattern for delimiters and special symbols; used to search for math in
      # the document.
      SPLIT = /(\$\$?|                        (?# 1 or 2 dollars)
                \\(?:begin|end)\{[a-z]*\*?\}| (?# latex envs)
                \\[\\{}$]|                    (?# \\ \{ \})
                [{}]|                         (?# braces )
                (?:\n\s*)+|                   (?# newlines w. optional spaces)
                @@\d+@@)                      (?# @@digits@@)
             /ix

      def initialize(document)
        reset_counters
        @math   = []
        @blocks = document.gsub(/\r\n?/, "\n").split(SPLIT)
      end

      # Replace math in document with +@@index@@+.
      # @return [String] document
      def filter
        @blocks.each_with_index do |block, i|
          case
          when '@' == block[0] # store math marker
            @blocks[i] = "@@#{@math.length}@@"
            @math << block
          when @start       # in math
            case block
            when @close     # process if braces match
              @braces.zero? ? process_math(i) : @last = i
            when /\n.*\n/   # don't go over double line breaks
              process_math if @last
              reset_counters
            when '{' then @braces += 1 # balance braces
            when '}' then @braces -= 1 if @braces > 0
            end
          else              # look for start delimiters
            case block
            when '$', '$$'
              @start, @close, @braces = i, block, 0
            when /\A\\begin\{([a-z]*\*?)\}/
              @start, @close, @braces = i, "\\end{#{$1}}", 0
            end
          end
        end
        process_math if @last
        @blocks.join
      end

      def replace(document)
        document.gsub(/@@(\d+)@@/) { @math[$1.to_i] }
      end

      private

      # Collects the math from blocks +i+ through +j+, replaces &, <, and > by
      # named entities, and resets that math positions.
      def process_math(last = @last)
        block = @blocks[@start..last].join
          .gsub(/&/, '&amp;')
          .gsub(/</, '&lt;')
          .gsub(/>/, '&gt;')
        last.downto(@start+1) { |k| @blocks[k] = '' }
        @blocks[@start] = "@@#{@math.length}@@"
        @math << block
        reset_counters
      end

      def reset_counters
        @start = @close = @last = nil
        @braces = 0
      end

    end

  end
end
