# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Run all examples"
task :examples do
  Dir["examples/*.rb"].each do |example|
    puts "\n📝 Running: #{example}"
    puts "=" * 50
    system("ruby #{example}")
    puts "=" * 50
  end
end

desc "Open an interactive console with the gem loaded"
task :console do
  require "pry"
  require_relative "lib/starlined"
  include Starlined::Messages
  runner = Starlined::Runner.new
  puts "Starlined loaded! Available:"
  puts "  - Messages module included (info, warn, error, success, etc.)"
  puts "  - runner = Starlined::Runner.new"
  puts "  - Starlined::Animation"
  Pry.start
end
