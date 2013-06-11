require 'active_support/core_ext/logger'

module Spirit

  # @see https://github.com/chriseppstein/compass/blob/stable/lib/compass/logger.rb
  class Logger < ::Logger

    COLORS = { clear: 0, red: 31, green: 32, blue: 35, yellow: 33, grey: 37 }.freeze

    ACTION_COLORS = {
      error:   :red,
      warning: :yellow,
      problem: :blue,
    }.freeze

    # Record that an action has occurred.
    def record(action, *args)
      msg = ''
      msg << color(ACTION_COLORS[action])
      msg << action_padding(action) + action.to_s
      msg << color(:clear)
      msg << ' ' + args.join(' ')
      info msg
    end

    private

    def color(c)
      (c and code = COLORS[c.to_sym]) ? "\e[#{code}m" : ''
    end

    # Adds padding to the left of an action that was performed.
    def action_padding(action)
      ' ' * [(max_action_length - action.to_s.length), 0].max
    end

    # the maximum length of all the actions known to the logger.
    def max_action_length
      @max_action_length ||= actions.reduce(0) { |m, a| [m, a.to_s.length].max }
    end

    def actions
      @actions ||= ACTION_COLORS.keys
    end

  end

end
