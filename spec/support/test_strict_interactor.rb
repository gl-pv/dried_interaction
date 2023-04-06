# frozen_string_literal: true

class TestStrictInteractor
  include DriedInteraction

  option :opts_handler, reader: :private, default: -> { ->(value) { Success(value) } }
  option :save_handler, reader: :private, default: -> { ->(value) { Success(value) } }

  contract do
    required(:req_int).filled(:integer)
    optional(:opt_bool).filled(:bool)
    optional(:opt_hash).hash do
      required(:req_h_int).filled(:integer)
    end
  end

  def call(options)
    prepared_options = yield opts_handler.call(options)

    save_handler.call(prepared_options)
  end
end
