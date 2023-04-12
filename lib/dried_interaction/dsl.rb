# frozen_string_literal: true

require 'dry/validation'
require 'dry/schema'

module DriedInteraction
  module Dsl
    MODES = %i[strict soft].freeze
    attr_accessor :contract_validator, :contract_mode

    def contract(kind: :simple, mode: MODES.first, &block)
      @contract_mode = resolve_contract_mode(mode)
      @contract_validator = resolve_contract_validator(kind, &block)
    end

    # soft_contract, strict_contract
    MODES.each do |mode|
      define_method("#{mode}_contract") do |args = {}, &block|
        contract(args.merge(mode: mode), &block)
      end
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
