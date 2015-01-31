require "prius/errors"

module Prius
  class Registry
    TYPES = [:string, :int, :bool]

    def initialize(env)
      @env = env
      @registry = {}
    end

    def load(name, env_var: nil, type: :string)
      env_var ||= name.to_s.upcase
      @registry[name] = case type
                        when :string then load_string(env_var)
                        when :int    then load_int(env_var)
                        when :bool   then load_bool(env_var)
                        else raise ArgumentError
                        end
    end

    def get(name)
      @registry.fetch(name)
    rescue KeyError
      raise UndeclaredNameError, "config value '#{name}' never loaded"
    end

    private

    def check_valid_type(type)
      unless TYPES.include?(type)
        raise ArgumentError, "invalid type '#{type}'"
      end
    end

    def load_string(name)
      @env.fetch(name)
    rescue KeyError
      raise MissingValueError, "config value '#{name}' not present"
    end

    def load_int(name)
      value = load_string(name)
      unless /\A[0-9]+\z/.match(value)
        raise TypeMismatchError, "'#{name}' value '#{value}' is not an integer"
      end
      value.to_i
    end

    def load_bool(name)
      value = load_string(name)
      if /\A(yes|y|true|t|1)\z/i.match(value)
        return true
      elsif /\A(no|n|false|f|0)\z/i.match(value)
        return false
      end
      raise TypeMismatchError, "'#{name}' value '#{value}' is not an boolean"
    end
  end
end
