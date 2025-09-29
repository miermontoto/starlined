# frozen_string_literal: true

require "open3"
require "colorize"

module Starlined
  class Runner
    attr_reader :animation

    def initialize
      @run_instances = 0
      @run_semaphore = Mutex.new
      @animation = nil
    end

    def start(message, steps: 0)
      stop_animation if @animation
      @animation = Animation.new(message, steps)
      @animation
    end

    def stop
      return unless @animation

      Messages.success(@animation.message, @animation.elapsed_time)
      stop_animation
    end

    def run(command, print_err = true, aka: nil, no_count: false)
      needs_sudo = !!(command =~ /^sudo/)

      execute(
        -> { Open3.capture3(command) },
        print_err,
        aka: aka,
        no_count: no_count,
        sudo: needs_sudo,
      )
    end

    def execute(callback, print_err = true, aka: nil, no_count: false, sudo: false)
      handle_sudo if sudo

      @run_semaphore.synchronize do
        @animation&.add_alias(aka) unless aka.nil?

        if @run_instances == 0 && @animation
          @animation.start
        end
        @run_instances += 1
      end

      result = callback.call

      @run_semaphore.synchronize do
        @run_instances -= 1
        @animation&.increment_step unless no_count
        @animation&.remove_alias(aka) unless aka.nil?

        if @run_instances == 0 && @animation
          @animation.stop
        end
      end

      handle_error(result, print_err) unless result.last.success?

      result
    end

    private

    def stop_animation
      @animation&.stop
      @animation = nil
    end

    def handle_sudo
      needs_password = !system("sudo -n true &>/dev/null")

      if needs_password || RUBY_PLATFORM.include?("darwin")
        stop_animation

        if needs_password
          # alertar al usuario con diferentes métodos
          print "\a" # terminal bell
          system("tput bel 2>/dev/null") # alternative bell
          Messages.info("Password required")
        end

        result = system("sudo -v")
        raise "Sudo privileges not granted" unless result

        @animation&.start if @run_instances != 0
      end
    end

    def handle_error(result, print_err)
      return unless print_err

      stop_animation
      Messages.error(nil, @animation&.message)

      puts result[1] # stderr
      puts result[0] if result[1].empty? # stdout si stderr está vacío

      Messages.verbose("Exit code: #{result.last.exitstatus}")
      exit 1
    end
  end
end
