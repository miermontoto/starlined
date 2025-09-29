# frozen_string_literal: true

require 'open3'
require 'colorize'

require_relative 'starlined/version'
require_relative 'starlined/configuration'
require_relative 'starlined/animation'
require_relative 'starlined/messages'
require_relative 'starlined/runner'

module Starlined
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def reset_configuration!
      self.configuration = Configuration.new
    end
  end

  # inicializar con configuración por defecto
  self.configuration = Configuration.new
end