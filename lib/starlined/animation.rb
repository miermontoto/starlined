# frozen_string_literal: true

require 'colorize'
require 'io/console'

module Starlined
  class Animation
    attr_reader :thread, :message, :start_time, :steps, :current_steps, :last_lines
    attr_accessor :aliases

    # líneas pendientes de limpiar (persiste entre instancias para que Messages pueda acceder)
    @pending_clear_lines = 1
    class << self
      attr_accessor :pending_clear_lines
    end

    def initialize(message = 'Booting up', steps = 0)
      @message = message
      @start_time = Time.now
      @steps = steps
      @current_steps = 0

      # variables de animación
      @pos = [0, 1, 2]
      @move = 1

      # manejo de aliases
      @aliases = []
      @alias_pointer = 0
      @alias_timer = 0
      @alias_semaphore = Mutex.new

      # semáforo para pasos
      @steps_semaphore = Mutex.new

      # líneas visuales que ocupa la última impresión
      @last_lines = 1

      @running = false
      @thread = nil
    end

    def start
      return if @running

      @running = true
      @thread = Thread.new { animation_loop }
    end

    def stop
      return unless @running

      @running = false
      @thread&.kill
      @thread = nil
    end

    def increment_step
      @steps_semaphore.synchronize do
        @current_steps += 1 if @current_steps < @steps
      end
    end

    def add_alias(aka)
      return if aka.nil?

      @alias_semaphore.synchronize { @aliases.push(aka) }
    end

    def remove_alias(aka)
      return if aka.nil?

      @alias_semaphore.synchronize do
        @aliases.delete(aka)
        # ajustar el puntero si se eliminó un elemento antes de la posición actual
        @alias_pointer = 0 if @alias_pointer >= @aliases.length && !@aliases.empty?
      end
    end

    def elapsed_time
      (Time.now - @start_time).round(2).to_s
    end

    private

    def animation_loop
      config = Starlined.configuration

      while @running
        stars = build_stars
        extra = build_extra_info

        clear_line
        output = "[#{stars}] #{@message.ljust(config.msg_ljust)} #{extra}"
        print "\r#{output}"
        @last_lines = visible_line_count(output)
        self.class.pending_clear_lines = @last_lines

        move_stars
        update_alias_timer

        sleep config.sleep_time
      end
    end

    def build_stars
      stars = ''
      config = Starlined.configuration

      config.stars_range.each do |i|
        stars += if !@pos.include?(i)
                   ' '
                 elsif i == @pos[1]
                   '*'.bold.red
                 else
                   '*'.yellow
                 end
      end

      stars
    end

    def build_extra_info
      config = Starlined.configuration
      extra = "#{elapsed_time}s".rjust(config.extra_rjust).light_black

      if @steps != 0
        steps_string = "#{@current_steps}/#{@steps}"
        alias_string = current_alias_string
        extra += " #{steps_string} #{alias_string.light_black.italic}"
      end

      extra
    end

    def current_alias_string
      @alias_semaphore.synchronize do
        return '' if @aliases.empty?

        begin
          @aliases[@alias_pointer].to_s
        rescue NoMethodError, ArgumentError
          @aliases.first.to_s unless @aliases.empty?
        end
      end
    end

    def move_stars
      config = Starlined.configuration

      # mover estrellas dependiendo del sentido del movimiento
      @pos = @pos.map { |p| (p + @move) % config.stars_range.length }

      # cambiar el sentido de movimiento si se toca alguno de los bordes
      @move = if @pos.first == config.stars_range.first
                1
              else
                @pos.last == config.stars_range.last ? -1 : @move
              end
    end

    def update_alias_timer
      @alias_semaphore.synchronize do
        return if @aliases.empty?

        @alias_timer += 1
        if @alias_timer >= 3
          @alias_timer = 0
          @alias_pointer = (@alias_pointer + 1) % @aliases.length
        end
      end
    end

    def clear_line
      clear = Starlined.configuration.clear_line_string
      # limpiar cada línea visual que ocupó la última impresión
      (@last_lines - 1).times { print "\e[1A#{clear}" }
      print "\r#{clear}"
    end

    def visible_line_count(str)
      cols = terminal_columns
      return 1 if cols <= 0

      # longitud visible sin escape sequences ANSI
      visible = str.gsub(/\e\[[0-9;]*m/, '')
      [(visible.length.to_f / cols).ceil, 1].max
    end

    def terminal_columns
      IO.console&.winsize&.last || 80
    rescue StandardError
      80
    end
  end
end
