#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/starlined"

runner = Starlined::Runner.new

puts "=== Animated Command Execution Example ==="
puts

# ejemplo simple con comandos secuenciales
runner.start("Running system checks", steps: 3)

runner.run("echo 'Checking disk space...' && sleep 1", aka: "disk check")
runner.run("echo 'Checking memory...' && sleep 1", aka: "memory check")
runner.run("echo 'Checking network...' && sleep 1", aka: "network check")

runner.stop

puts

# ejemplo con comandos más complejos
runner.start("Installing dependencies", steps: 2)

runner.run("echo 'Fetching package list...' && sleep 2", aka: "apt update")
runner.run("echo 'Installing packages...' && sleep 2", aka: "apt install")

runner.stop

puts

# ejemplo con manejo de errores (comentado para no interrumpir)
# runner.start("Testing error handling")
# runner.run("false", aka: "failing command") # este comando fallará
# runner.stop

puts "=== End of Animated Examples ==="
