# Starlined

A Ruby gem that provides beautiful terminal output utilities with animated star progress indicators, colored messages, and command execution with visual feedback.

## Features

- 🌟 **Animated Progress Indicators** - Beautiful star animations that move while commands execute
- 🎨 **Colored Messages** - Error, info, warning, and success messages with appropriate colors
- 🔄 **Thread-Safe Operations** - Safe to use with parallel command execution
- ⚡ **Command Runner** - Execute shell commands with automatic progress animation
- 🔧 **Highly Configurable** - Customize animation speed, message formatting, and more

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'starlined'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install starlined
```

## Usage

### Basic Message Output

```ruby
require 'starlined'

# include the messages module for easy access
include Starlined::Messages

# display various message types
info("Starting application...")
warn("Configuration file not found, using defaults")
error("Connection failed", "Database timeout")
success("Build completed", 3.5) # with elapsed time
verbose("Debug information") # only shown if verbose mode is enabled
```

### Animated Command Execution

```ruby
runner = Starlined::Runner.new

# start an animation with a message
runner.start("Installing dependencies", steps: 3)

# run commands with animation
runner.run("bundle install", aka: "bundler")
runner.run("npm install", aka: "npm")
runner.run("rake db:migrate", aka: "migrations")

# stop animation and show success
runner.stop
```

### Interactive Input

```ruby
include Starlined::Messages

response = ask("What's your project name?")
puts "Creating project: #{response}"
```

### Configuration

```ruby
Starlined.configure do |config|
  config.verbose = true          # enable verbose output
  config.sleep_time = 0.5        # animation speed (seconds)
  config.msg_ljust = 40          # message padding
  config.stars_range = (0..7)    # animation width
end
```

### Advanced Usage with Parallel Execution

```ruby
runner = Starlined::Runner.new
runner.start("Running tests", steps: 3)

threads = []
threads << Thread.new { runner.run("rspec spec/models", aka: "models") }
threads << Thread.new { runner.run("rspec spec/controllers", aka: "controllers") }
threads << Thread.new { runner.run("rspec spec/helpers", aka: "helpers") }

threads.each(&:join)
runner.stop
```

### Using Animation Directly

```ruby
animation = Starlined::Animation.new("Processing files", steps: 100)
animation.start

100.times do |i|
  # do some work
  sleep(0.1)
  animation.increment_step
  animation.add_alias("file_#{i}.txt")
  # more work
  animation.remove_alias("file_#{i}.txt")
end

animation.stop
```

## Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `sleep_time` | `0.75` | Time between animation frames (seconds) |
| `msg_ljust` | `30` | Left padding for messages |
| `extra_rjust` | `8` | Right padding for extra info |
| `stars_range` | `(0..5)` | Range for star animation positions |
| `verbose` | `false` | Enable verbose output |
| `clear_line_string` | `"\33[2K"` | ANSI code to clear terminal line |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/starlined.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Created by Mier - Extracted from the Okticket builder script utilities.