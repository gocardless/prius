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
      env_var = name.to_s.upcase if env_var.nil?
      value = load_value(env_var, required)
      @registry[name] = case type
                        when :string then value
                        when :int    then parse_int(env_var, value)
                        when :bool   then parse_bool(env_var, value)
                        when :date   then parse_date(env_var, value)
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

    def load_value(name, required)
      @env.fetch(name)
    rescue KeyError
      return nil unless required

      raise MissingValueError, "config value '#{name}' not present"
    end

    def parse_int(name, value)
      unless /\A[0-9]+\z/.match?(value)
        raise TypeMismatchError, "'#{name}' value '#{value}' is not an integer"
      end

      value.to_i
    end

    def parse_bool(name, value)
      value = value.downcase
      return true if %w[yes y true t 1].include?(value)
      return false if %w[no n false f 0].include?(value)

      raise TypeMismatchError, "'#{name}' value '#{value}' is not a boolean"
    end

    def parse_date(name, value)
      Date.parse(value)
    rescue ArgumentError
      raise TypeMismatchError, "'#{name}' value '#{value}' is not a date"
    end
  end
end
