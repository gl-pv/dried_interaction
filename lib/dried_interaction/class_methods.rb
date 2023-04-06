# frozen_string_literal: true

require 'dry/validation'
require 'dry/schema'

module DriedInteraction
  module ClassMethods
    MODES = %i[strict soft].freeze
    attr_accessor :contract_validator, :contract_mode

    def contract(kind: :simple, mode: MODES.first, &block)
      @contract_mode = resolve_contract_mode(mode)
      @contract_validator = resolve_contract_validator(kind, &block)
    end

    def resolve_contract_mode(mode)
      MODES.include?(mode.to_sym) ? mode.to_sym : (raise ArgumentError)
    end

    def resolve_contract_validator(kind, &block)
      case kind
      when :simple
        Dry::Schema.Params(&block)
      when :extended
        Dry::Validation.Contract(&block)
      else
        raise ArgumentError
      end
    end
  end
end
