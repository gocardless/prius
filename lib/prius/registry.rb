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
    def load(name, options = {})
      env_var = options.fetch(:env_var, name.to_s.upcase)
      type = options.fetch(:type, :string)
      required = options.fetch(:required, true)
      @registry[name] = case type
                        when :string then load_string(env_var, required)
                        when :int    then load_int(env_var, required)
                        when :bool   then load_bool(env_var, required)
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

      unless /\A[0-9]+\z/.match(value)
        raise TypeMismatchError, "'#{name}' value '#{value}' is not an integer"
      end
      value.to_i
    end

    def load_bool(name, required)
      value = load_string(name, required)
      return nil if value.nil?

      if /\A(yes|y|true|t|1)\z/i.match(value)
        return true
      elsif /\A(no|n|false|f|0)\z/i.match(value)
        return false
      end
      raise TypeMismatchError, "'#{name}' value '#{value}' is not an boolean"
    end
  end
end
