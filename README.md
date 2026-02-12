# starlined 🌟

terminal output gem with animated stars, colored messages, and progress tracking.

## install

```ruby
gem 'starlined'
```

## usage

### basic messages

```ruby
require 'starlined'
include Starlined::Messages

info "Starting deployment"
warn "Config file missing"
error "Connection failed"
success "Build complete", 3.5  # with elapsed time
```

### run with animation (sequentially)

```ruby
runner = Starlined::Runner.new
runner.start("Installing deps", steps: 3)

runner.run("bundle install", aka: "bundler")
runner.run("npm install", aka: "npm")
runner.run("rake db:migrate", aka: "database")

runner.stop
```

The `aka` parameter shows what's currently running in the animation.

### run in parallel

```ruby
runner = Starlined::Runner.new
runner.start("Running tests", steps: 3)

threads = []
threads << Thread.new { runner.run("rspec spec/models") }
threads << Thread.new { runner.run("rspec spec/controllers") }
threads << Thread.new { runner.run("rspec spec/features") }
threads.each(&:join)

runner.stop
```

### custom configuration

```ruby
Starlined.configure do |config|
  config.verbose = true        # show verbose messages
  config.sleep_time = 0.5      # animation speed
  config.msg_ljust = 40        # message padding
end
```

## license

CC-NC-BY-4.0, open-sourced from [okticket](https://okticket.es)
