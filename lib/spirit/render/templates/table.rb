# ~*~ encoding: utf-8 ~*~
module Spirit

  module Render

    # Renders table problems marked up in YAML as HTML.
    #
    # The grid should be given as a 2-dimensional array that represents the
    # table to be filled in. +"?"+ is a special token used in the grid to
    # indicate cells that require student input.
    #
    # The answer should also be given as a 2-dimensional array. However, a
    # dummy token may be used in cells that do not require student input to
    # cut redundancy. In the example below, the +"-"+ token is used.
    #
    # @example
    #     {
    #       "format": "table",
    #       "question": "fill me in",
    #       "grid": [[0, "?", 2], [3, "?", 5]],
    #       "answer": [["-", 1, "-"],  ["-", 4, "-"]
    #     }
    class Table < Problem

      # Name of template file for rendering table problems.
      TEMPLATE = 'table.haml'

      # Optional headings key.
      HEADINGS = 'headings'

      # Required grid key.
      GRID = 'grid'

      # Special token indicating that the cell should be filled in.
      FILL_ME_IN = '?'

      accessor HEADINGS, GRID

      # Ensures that the +headings+ key exists.
      def initialize(yaml, digest, id = 0)
        yaml[HEADINGS] ||= nil
        super
      end

      # Checks if the given yaml contains a valid table.
      # @return [Boolean] true iff the yaml contains a valid table.
      def valid?
        super and
          valid_grid? and
          valid_answer?
      end

      # Gets the expected answer, in www-form-urlencoded format.
      # @return [Hash] answers, as expected from student's form submission
      def answer
        return @answer unless @answer.nil?
        @answer = encode_answer
      end

      # @return [Boolean] true iff the given cell is an input cell
      def self.input?(cell)
        cell == FILL_ME_IN
      end

      private

      # Iterates through each cell in the provided grid to look for answers
      # cells that require input and takes the answer from the answers array.
      # For example, if the answer for a cell at [0][1] is 6, the returned
      # hash will contain
      #
      #     {'0' => {'1' => 6}}
      #
      # @return [Hash] answers
      def encode_answer
        encoded, ans = {}, @yaml[ANSWER]
        grid.each_with_index do |row, i|
          row.each_with_index do |cell, j|
            next unless Table.input? cell
            encoded[i.to_s] ||= {}
            encoded[i.to_s][j.to_s] = serialize ans[i][j]
          end
        end
        encoded
      end

      # @return [Boolean] true iff the yaml contains a valid grid.
      def valid_grid?
        @yaml.has_key? GRID and is_2d_array? grid
      end

      # @return [Boolean] true iff +answer+ is a valid 2D array and has the
      # same number of rows as +grid+.
      def valid_answer?
        ans = @yaml[ANSWER]
        is_2d_array? ans and ans.size == grid.size
      end

      # @return [Boolean] true iff +t+ is a 2-dimensional array.
      def is_2d_array?(t)
        t.is_a? Array and t.all? { |row| row.is_a? Array }
      end

    end

  end

end

