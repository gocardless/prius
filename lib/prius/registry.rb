# frozen_string_literal: true

require "date"
require "prius/errors"

module Prius
  class Registry
    # Initialise a Registry.
    #
    # env - A Hash used as a source for environment variables. Usually, ENV
    #       will be used.
    def initialize(env)
      @env = env
      @registry = {}
    end

    # See Prius.load for documentation.
    def load(name, env_var: nil, type: :string, required: true)
      env_var = env_var.nil? ? name.to_s.upcase : env_var
      @registry[name] = case type
                        when :string then load_string(env_var, required)
                        when :int    then load_int(env_var, required)
                        when :bool   then load_bool(env_var, required)
                        when :date   then load_date(env_var, required)
                        else raise ArgumentError, "Invalid type #{type}"
                        end
    end

    # See Prius.get for documentation.
    def get(name)
      @registry.fetch(name)
    rescue KeyError
      raise UndeclaredNameError, "config value '#{name}' never loaded"
    end

    private

    def load_string(name, required)
      @env.fetch(name)
    rescue KeyError
      return nil unless required

      raise MissingValueError, "config value '#{name}' not present"
    end

    def load_int(name, required)
      value = load_string(name, required)
      return value if value.nil?

      unless /\A[0-9]+\z/.match?(value)
        raise TypeMismatchError, "'#{name}' value '#{value}' is not an integer"
      end

      value.to_i
    end

    def load_bool(name, required)
      value = load_string(name, required)
      return nil if value.nil?
      return true if %w[yes y true t 1].include?(value)
      return false if %w[no n false f 0].include?(value)

      raise TypeMismatchError, "'#{name}' value '#{value}' is not a boolean"
    end

    def load_date(name, required)
      value = load_string(name, required)
      return nil if value.nil?

      Date.parse(value)
    rescue ArgumentError
      raise TypeMismatchError, "'#{name}' value '#{value}' is not a date"
    end
  end
end
