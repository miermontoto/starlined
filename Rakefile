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
  require_relative "lib/mier_output"
  include MierOutput::Messages
  runner = MierOutput::Runner.new
  puts "MierOutput loaded! Available:"
  puts "  - Messages module included (info, warn, error, success, etc.)"
  puts "  - runner = MierOutput::Runner.new"
  puts "  - MierOutput::Animation"
  Pry.start
end
