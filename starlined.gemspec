# frozen_string_literal: true

require_relative "lib/starlined/version"

Gem::Specification.new do |spec|
  spec.name = "starlined"
  spec.version = Starlined::VERSION
  spec.authors = ["Mier"]
  spec.email = ["your.email@example.com"]

  spec.summary = "Terminal output utilities with animated progress indicators"
  spec.description = "A Ruby gem providing beautiful terminal output with animated star indicators, colored messages, and command execution with visual feedback"
  spec.homepage = "https://github.com/yourusername/starlined"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # especificar qué archivos deben incluirse en el gem
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # dependencias en tiempo de ejecución
  spec.add_dependency "colorize", "~> 0.8"

  # dependencias de desarrollo
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "simplecov", "~> 0.21"
end
