# frozen_string_literal: true

module Starlined
  class Configuration
    attr_accessor :sleep_time, :msg_ljust, :extra_rjust, :stars_range,
                  :verbose, :clear_line_string

    def initialize
      @sleep_time = 0.75
      @msg_ljust = 30
      @extra_rjust = 8
      @stars_range = (0..5).to_a
      @verbose = false
      @clear_line_string = "\33[2K"
    end
  end
end