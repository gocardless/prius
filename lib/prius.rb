require "prius/registry"
require "prius/railtie" if defined?(Rails)

module Prius
  def self.load(name, type: :string, allow_nil: false)
    registry.load(name, type: type, allow_nil: allow_nil)
  end

  def self.get(name)
    registry.get(name)
  end

  def self.registry
    @registry ||= Registry.new(ENV)
  end
end
