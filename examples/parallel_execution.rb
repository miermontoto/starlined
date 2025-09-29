#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/starlined'

runner = Starlined::Runner.new

puts "=== Parallel Execution Example ==="
puts

runner.start("Running parallel tasks", steps: 4)

# crear múltiples hilos que ejecutan comandos en paralelo
threads = []

threads << Thread.new do
  runner.run("echo 'Task 1 starting' && sleep 2 && echo 'Task 1 done'", aka: "task-1")
end

threads << Thread.new do
  runner.run("echo 'Task 2 starting' && sleep 3 && echo 'Task 2 done'", aka: "task-2")
end

threads << Thread.new do
  runner.run("echo 'Task 3 starting' && sleep 1 && echo 'Task 3 done'", aka: "task-3")
end

threads << Thread.new do
  runner.run("echo 'Task 4 starting' && sleep 2.5 && echo 'Task 4 done'", aka: "task-4")
end

# esperar a que todos los hilos terminen
threads.each(&:join)

runner.stop

puts
puts "All parallel tasks completed!"
puts

# ejemplo más realista: ejecutar diferentes tipos de tests en paralelo
runner.start("Running test suite", steps: 3)

test_threads = []

test_threads << Thread.new do
  runner.run("echo 'Running unit tests...' && sleep 2", aka: "unit-tests")
end

test_threads << Thread.new do
  runner.run("echo 'Running integration tests...' && sleep 3", aka: "integration-tests")
end

test_threads << Thread.new do
  runner.run("echo 'Running linter...' && sleep 1.5", aka: "linter")
end

test_threads.each(&:join)

runner.stop

puts
puts "=== End of Parallel Examples ==="