# frozen_string_literal: true

module Prius
  class MissingValueError < StandardError; end
  class TypeMismatchError < StandardError; end
  class UndeclaredNameError < StandardError; end
  class InvalidLoadError < StandardError; end
end
