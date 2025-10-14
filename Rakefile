# frozen_string_literal: true

require "bundler/gem_tasks"
require_relative "lib/starlined/version"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  # rspec not available
end

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

# Version management tasks
namespace :version do
  desc "Show current version"
  task :current do
    puts "Current version: #{Starlined::VERSION}"
  end

  def bump_version(type)
    version_file = "lib/starlined/version.rb"
    content = File.read(version_file)

    current_version = Starlined::VERSION
    major, minor, patch = current_version.split(".").map(&:to_i)

    case type
    when :major
      new_version = "#{major + 1}.0.0"
    when :minor
      new_version = "#{major}.#{minor + 1}.0"
    when :patch
      new_version = "#{major}.#{minor}.#{patch + 1}"
    end

    new_content = content.gsub(/VERSION = ['"]#{Regexp.escape(current_version)}['"]/, "VERSION = '#{new_version}'")
    File.write(version_file, new_content)

    puts "Version bumped from #{current_version} to #{new_version}"
    new_version
  end

  desc "Bump major version (x.0.0)"
  task :major do
    bump_version(:major)
  end

  desc "Bump minor version (0.x.0)"
  task :minor do
    bump_version(:minor)
  end

  desc "Bump patch version (0.0.x)"
  task :patch do
    bump_version(:patch)
  end
end

# Release tasks
namespace :release do
  def release(type)
    # Bump version
    puts "📝 Bumping #{type} version..."
    new_version = nil
    Rake::Task["version:#{type}"].invoke

    # Reload version
    load "lib/starlined/version.rb"
    new_version = Starlined::VERSION

    # Build gem
    puts "\n📦 Building gem..."
    system("gem build starlined.gemspec") or abort("Build failed!")

    # Ask for confirmation before pushing
    print "\n🚀 Push starlined-#{new_version}.gem to RubyGems? (y/n): "
    response = STDIN.gets.chomp.downcase

    if response == 'y'
      puts "Pushing to RubyGems..."
      system("gem push starlined-#{new_version}.gem") or abort("Push failed!")
      puts "\n✅ Successfully released version #{new_version}!"
    else
      puts "❌ Push cancelled. Gem built but not pushed."
      puts "   You can manually push with: gem push starlined-#{new_version}.gem"
    end
  end

  desc "Release new major version (x.0.0)"
  task :major do
    release(:major)
  end

  desc "Release new minor version (0.x.0)"
  task :minor do
    release(:minor)
  end

  desc "Release new patch version (0.0.x)"
  task :patch do
    release(:patch)
  end
end

# Quick release aliases
desc "Release patch version (alias for release:patch)"
task :patch => "release:patch"

desc "Release minor version (alias for release:minor)"
task :minor => "release:minor"

desc "Release major version (alias for release:major)"
task :major => "release:major"