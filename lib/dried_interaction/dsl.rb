# frozen_string_literal: true

require 'dry/validation'
require 'dry/schema'
require 'dried_interaction/instance_methods'

module DriedInteraction
  module Dsl
    MODES = %i[strict soft].freeze
    attr_accessor :contract_validator, :contract_mode, :for_method

    def contract(kind: :simple, mode: MODES.first, &block)
      @contract_mode = resolve_contract_mode(mode)
      @contract_validator = resolve_contract_validator(kind, &block)
    end

    def soft_contract(args = {}, &block)
      contract(args.merge(mode: :soft), &block)
    end

    def strict_contract(args = {}, &block)
      contract(args.merge(mode: :strict))
    end

    private

    def resolve_contract_mode(mode)
      MODES.include?(mode.to_sym) ? mode.to_sym : (raise ArgumentError)
    end

    def resolve_contract_validator(kind, &block)
      case kind
      when :simple
        Dry::Schema.Params(&block)
      when :extended
        Dry::Validation.Contract(&block)
      when Dry::Schema::Params
        kind.merge(Dry::Schema.Params(&block))
      when Dry::Validation::Contract
        kind.build(&block)
      else
        raise ArgumentError
      end
    end
  end
end
