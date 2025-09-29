#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/starlined'

include Starlined::Messages

puts "=== Basic Message Examples ==="
puts

info("This is an information message")
sleep(1)

warn("This is a warning message")
sleep(1)

success("Operation completed successfully", 2.5)
sleep(1)

# configurar modo verbose
Starlined.configure do |config|
  config.verbose = true
end

verbose("This verbose message is now visible")
sleep(1)

# ejemplo con error (comentado para no salir del programa)
# error("Something went wrong", "Connection timeout")

# entrada interactiva
name = ask("What's your name?")
info("Hello, #{name}!")

puts
puts "=== End of Basic Examples ==="