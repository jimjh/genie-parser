module Spirit
  module Render
    module Processors

      # Pre-processes math markup in latex.
      # Adapted from
      # http://www.math.union.edu/~dpvc/transfer/mathjax/mathjax-editing.js
      class MathProcessor < Base

        process :preprocess,  :filter
        process :postprocess, :replace

        # Pattern for delimiters and special symbols; used to search for math in
        # the document.
        SPLIT = /(\$\$?|                        (?# 1 or 2 dollars)
                  \\(?:begin|end)\{[a-z]*\*?\}| (?# latex envs)
                  \\[\\{}$]|                    (?# \\ \{ \})
                  [{}]|                         (?# braces )
                  (?:\n\s*)+|                   (?# newlines w. optional spaces)
                  @@\d+@@)                      (?# @@digits@@)
               /ix

        def initialize(renderer, document)
          reset_counters
          @math   = []
          @blocks = document.gsub(/\r\n?/, "\n").split SPLIT
        end

        # Replace math in document with +@@index@@+.
        # @return [String] document
        def filter(document)
          blocks.each_with_index do |block, i|
            case
            when '@' == block[0]
              process_pseudo_marker block, i
            when @start
              process_potential_close block, i
            else
              process_potential_start block, i
            end
          end
          process_math if @last
          blocks.join
        end

        def replace(document)
          document.gsub(/@@(\d+)@@/) { math[$1.to_i] }
        end

        private

        attr_reader :blocks, :math

        def process_pseudo_marker(block, i)
          blocks[i] = "@@#{math.length}@@"
          math << block
        end

        def process_potential_start(block, i)
          case block
          when '$', '$$'
            @start, @close, @braces = i, block, 0
          when /\A\\begin\{([a-z]*\*?)\}/
            @start, @close, @braces = i, "\\end{#{$1}}", 0
          end
        end

        def process_potential_close(block, i)
          case block
          when @close     # process if braces match
            @braces.zero? ? process_math(i) : @last = i
          when /\n.*\n/   # don't go over double line breaks
            process_math if @last
            reset_counters
          when '{' then @braces += 1 # balance braces
          when '}' then @braces -= 1 if @braces > 0
          end
        end

        # Collects the math from blocks +i+ through +j+, replaces &, <, and > by
        # named entities, and resets that math positions.
        def process_math(last = @last)
          block = blocks[@start..last].join
            .gsub(/&/, '&amp;')
            .gsub(/</, '&lt;')
            .gsub(/>/, '&gt;')
          last.downto(@start+1) { |k| blocks[k] = '' }
          blocks[@start] = "@@#{math.length}@@"
          math << block
          reset_counters
        end

        def reset_counters
          @start = @close = @last = nil
          @braces = 0
        end

      end

    end
  end
end
