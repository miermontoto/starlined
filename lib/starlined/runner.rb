# frozen_string_literal: true

require 'open3'
require 'colorize'

module Starlined
  class Runner
    attr_reader :animation

    def initialize
      @running_instances = 0
      @run_semaphore = Mutex.new
      @animation = nil
    end

    def start(message, steps: 0)
      stop_animation
      @animation = Animation.new(message, steps)
    end

    def stop
      return unless @animation

      Messages.success(@animation.message, @animation.elapsed_time)
      stop_animation
    end

    def run(command, print_err: true, aka: nil, no_count: false)
      needs_sudo = !!(command =~ /^sudo/)

      execute(
        -> { Open3.capture3(command) },
        print_err: print_err,
        aka: aka,
        no_count: no_count,
        sudo: needs_sudo
      )
    end

    def pass_step
      @animation&.increment_step
    end

    def execute(callback, print_err: true, aka: nil, no_count: false, sudo: false)
      handle_sudo if sudo

      start_step(aka: aka)
      result = callback.call
      end_step(aka: aka, no_count: no_count)

      handle_error(result, print_err, aka) unless result.last.success?

      result
    end

    private

    def start_step(aka: nil)
      @run_semaphore.synchronize do
        @animation&.add_alias(aka) unless aka.nil?

        @animation.start if @running_instances.zero? && @animation
        @running_instances += 1
      end

      @running_instances
    end

    def end_step(aka: nil, no_count: false)
      @run_semaphore.synchronize do
        @running_instances -= 1
        @animation&.increment_step unless no_count
        @animation&.remove_alias(aka) unless aka.nil?

        @animation.stop if @running_instances.zero? && @animation
      end
    end

    def stop_animation
      return unless @animation

      @animation&.stop
      @animation = nil
    end

    def handle_sudo
      needs_password = !system('sudo -n true &>/dev/null')
      return unless needs_password || RUBY_PLATFORM.include?('darwin')

      stop_animation

      if needs_password
        # alertar al usuario con diferentes métodos
        print "\a" # terminal bell
        system('tput bel 2>/dev/null') # alternative bell
        Messages.info('Password required')
      end

      result = system('sudo -v')
      raise 'Sudo privileges not granted' unless result

      @animation&.start unless @running_instances.zero?
    end

    def handle_error(result, print_err, aka = nil)
      return unless print_err

      message = @animation&.message
      stop_animation
      Messages.error(aka, message)

      puts result[1] # stderr
      puts result[0] if result[1].empty? # stdout si stderr está vacío

      Messages.vrbose("Exit code: #{result.last.exitstatus}")
      exit 1
    end
  end
end
