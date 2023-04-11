# frozen_string_literal: true

CustomSchema = Dry::Schema.Params do
  # You can add some configurations here
  required(:req_int).filled(:integer)
end

class CustomSchemaInteractor
  include DriedInteraction

  option :opts_handler, reader: :private, default: -> { ->(value) { Success(value) } }
  option :save_handler, reader: :private, default: -> { ->(value) { Success(value) } }

  contract(kind: CustomSchema) do
    optional(:opt_hash).hash do
      required(:req_h_int).filled(:integer)
    end
  end

  def call(options)
    prepared_options = yield opts_handler.call(options)

    save_handler.call(prepared_options)
  end
end
