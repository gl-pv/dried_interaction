# frozen_string_literal: true

require 'dry/validation'
require 'dry/schema'

module DriedInteraction
  module ClassMethods
    attr_accessor :contract_validator

    def contract(kind = :simple, &block)
      case kind
      when :simple
        @contract_validator = Dry::Schema.Params(&block)
      when :extended
        @contract_validator = Dry::Validation.Contract(&block)
      else
        raise ArgumentError
      end
    end
  end
end
