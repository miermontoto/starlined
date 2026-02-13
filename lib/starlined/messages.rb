# frozen_string_literal: true

require 'colorize'

module Starlined
  module Messages
    extend self

    def error(message = nil, context = nil)
      clear_line
      output = "\r[#{'FAILED'.red}] #{context || 'Operation failed'}"
      output += " (#{message})" unless message.nil?
      puts output
    end

    def info(message)
      clear_line
      puts "\r[ #{'INFO'.blue} ] #{message}"
    end

    def warn(message)
      clear_line
      puts "\r[ #{'WARN'.yellow} ] #{message}"
    end

    def success(message, time = nil)
      clear_line
      output = "\r[  #{'OK'.green}  ] #{message}"
      if time
        dots = '.' * [3, 36 - message.length - time.to_s.length].max
        output += " #{dots.bold.gray} #{time}s"
      end
      puts output
    end

    def vrbose(message)
      return unless Starlined.configuration.verbose

      clear_line
      puts "\r[#{'VRBOSE'.light_black}] #{message}"
    end

    def ask(prompt)
      clear_line
      print "\r[  #{'??'.light_blue}  ] #{prompt}: "
      $stdin.gets.chomp
    end

    private

    def clear_line
      print "\r#{Starlined.configuration.clear_line_string}"
    end
  end
end
