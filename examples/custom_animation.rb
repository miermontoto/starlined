#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/starlined"

puts "=== Custom Animation Example ==="
puts

# configuración personalizada
Starlined.configure do |config|
  config.sleep_time = 0.3        # animación más rápida
  config.stars_range = (0..8)    # animación más ancha
  config.msg_ljust = 35         # mensajes más largos
end

# usar la animación directamente
animation = Starlined::Animation.new("Processing large dataset", steps: 10)
animation.start

10.times do |i|
  # simular procesamiento de archivos
  file_name = "data_chunk_#{i + 1}.csv"
  animation.add_alias(file_name)

  # simular trabajo
  sleep(0.5 + rand * 0.5)

  animation.increment_step
  animation.remove_alias(file_name)
end

animation.stop

# limpiar y mostrar resultado
include Starlined::Messages
success("Dataset processed", animation.elapsed_time)

puts

# otro ejemplo con múltiples aliases simultáneos
animation2 = Starlined::Animation.new("Downloading files", steps: 5)
animation2.start

# agregar múltiples aliases (simular descargas paralelas)
animation2.add_alias("file1.zip")
animation2.add_alias("file2.tar.gz")
animation2.add_alias("file3.json")

5.times do |i|
  sleep(1)
  animation2.increment_step

  # eliminar un alias cuando "termina" la descarga
  animation2.remove_alias("file#{i}.zip") if i < 3
end

animation2.stop
success("All files downloaded", animation2.elapsed_time)

puts
puts "=== End of Custom Animation Examples ==="
