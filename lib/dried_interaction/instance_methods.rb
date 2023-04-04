# frozen_string_literal: true

require 'dried_interaction/error'

module DriedInteraction
  module InstanceMethods
    def call(*args)
      interaction_contract_error('Call method allows only one argument') if args.size != 1

      arg = args.first
      contract = self.class.contract_validator
      contract_params = fetch_contract_params(contract)
      check_params_presence_in_args(contract_params, arg.keys)

      contract_result = contract.(arg)
      return interaction_contract_error(contract_result.errors.messages) if contract_result.failure?

      super(arg)
    end

    def check_params_presence_in_args(contract_params, args_params)
      missed_params = args_params - contract_params
      return if missed_params.empty?

      interaction_contract_error("Params (#{missed_params}) are not present in contract")
    end

    def fetch_contract_params(contract)
      schema = contract.is_a?(Dry::Schema::Params) ? contract : contract.schema

      schema.key_map.keys.map { |key| key.name.to_sym }
    end

    def interaction_contract_error(msgs)
      raise DriedInteractionError, class: self.class.to_s, errors: Array.wrap(msgs).join('; ')
    end
  end
end
