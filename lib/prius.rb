# frozen_string_literal: true

require "prius/registry"
require "prius/railtie" if defined?(Rails)

module Prius
  # Load an environment variable into the registry.
  #
  # name    - The Symbol name of the item in the registry. Use this when
  #           looking up the item via `#get`. If `env_var` is not provided
  #           this will be uppercased and used as the environment variable name.
  # options - An optional Hash of options (default {}):
  #           :env_var  - The String name of the environment variable. If
  #                       omitted the uppercased form of `name` will be used.
  #           :type     - The Symbol type of the environment variable's value.
  #                       The value will be coerced to this type. Must be one
  #                       of :string, :int, or :bool (default :string).
  #           :required - A Boolean indicating whether the value must be
  #                       present in the environment. If true, a
  #                       MissingValueError exception will be raised if the
  #                       value isn't present in the environment. Otherwise,
  #                       the value will be set to `nil` if the environment
  #                       variable isn't present (default true).
  #
  # Raises a MissingValueError for required values that are missing.
  # Raises a TypeMismatchError if a value can't be coerced to the given `type`.
  # Raises an ArgumentError if an invalid `type` is provided.
  def self.load(name, options = {})
    registry.load(name, options)
  end

  # Fetch a value from the registry.
  #
  # name - The Symbol name of the variable to look up. The name must have
  #        previously been `#load`ed into the registry.
  #
  # Raises UndeclaredNameError if the name provided has not been loaded into
  # the registry.
  def self.get(name)
    registry.get(name)
  end

  # Internal: accessor for the shared registry.
  def self.registry
    @registry ||= Registry.new(ENV)
  end
  private_class_method :registry
end
