require "prius/errors"

module Prius
  class Registry
    TYPES = [:string, :int, :bool]

    def initialize(env)
      @env = env
      @registry = {}
    end

    def load(name, env_var: nil, type: :string, allow_nil: false)
      env_var ||= name.to_s.upcase
      @registry[name] = case type
                        when :string then load_string(env_var, allow_nil)
                        when :int    then load_int(env_var, allow_nil)
                        when :bool   then load_bool(env_var, allow_nil)
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
      raise ArgumentError, "invalid type '#{type}'" unless TYPES.include?(type)
    end

    def load_string(name, allow_nil)
      @env.fetch(name)
    rescue KeyError
      return nil if allow_nil
      raise MissingValueError, "config value '#{name}' not present"
    end

    def load_int(name, allow_nil)
      value = load_string(name, allow_nil)
      return value if value.nil?

      unless /\A[0-9]+\z/.match(value)
        raise TypeMismatchError, "'#{name}' value '#{value}' is not an integer"
      end
      value.to_i
    end

    def load_bool(name, allow_nil)
      value = load_string(name, allow_nil)
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
