require "prius/registry"

module Prius
  def self.load(name, type: :string)
    registry.load(name, type: type)
  end

  def self.get(name)
    registry.get(name)
  end

  def self.registry
    @registry ||= Registry.new(ENV)
  end
end
