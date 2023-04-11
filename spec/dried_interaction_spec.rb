# frozen_string_literal: true

require 'dry/monads/all'

RSpec.describe DriedInteraction do
  include Dry::Monads

  let(:handlers) { {} }
  let(:options) { {} }

  describe 'interactor with strict mode' do
    subject { TestStrictInteractor.new(handlers).call(options) }

    context 'when contract params are valid' do
      let(:options) do
        { req_int: 1, opt_bool: true, opt_hash: { req_h_int: 2 } }
      end

      context 'when handler returns Success monad' do
        it { is_expected.to eq(Success(options)) }
      end

      context 'when handler returns Failure monad' do
        let(:expected_error) { 'Error message' }
        let(:handlers) { { opts_handler: ->(_value) { Failure(expected_error) } } }

        it { is_expected.to eq(Failure(expected_error)) }
      end
    end

    context 'when contract params are invalid' do
      let(:options) do
        { req_int: 'string', opt_bool: true, opt_hash: { req_h_int: 2 } }
      end

      it { expect { subject }.to raise_error { DriedInteractionError } }
    end
  end

  describe 'interactor with soft mode' do
    subject do
      TestSoftInteractor.new(handlers).call(options) do |res|
        res.success { |result| result }
        res.failure(:test) { |_result| 'Impossible error' }
        res.failure(DriedInteractionError) { |_result| 'DriedInteractionError' }
        res.failure { |result| result }
      end
    end

    context 'when contract params are valid' do
      let(:options) do
        { req_int: 1, opt_hash: { req_h_int: 2 } }
      end

      context 'when handler returns Success monad' do
        it { is_expected.to eq(options) }
      end

      context 'when handler returns Failure monad' do
        let(:expected_error) { 'Error message' }
        let(:handlers) { { opts_handler: ->(_value) { Failure(expected_error) } } }

        it { is_expected.to eq(expected_error) }
      end
    end

    context 'when contract params are invalid' do
      let(:options) do
        { req_int: 'string', opt_hash: { req_h_int: 2 } }
      end

      it { is_expected.to eq('DriedInteractionError') }
    end
  end

  describe 'interactor with custom schema' do
    subject { CustomSchemaInteractor.new(handlers).call(options) }

    context 'when contract params are valid' do
      let(:options) do
        { req_int: 1, opt_hash: { req_h_int: 2 } }
      end

      context 'when handler returns Success monad' do
        it { is_expected.to eq(Success(options)) }
      end

      context 'when handler returns Failure monad' do
        let(:expected_error) { 'Error message' }
        let(:handlers) { { opts_handler: ->(_value) { Failure(expected_error) } } }

        it { is_expected.to eq(Failure(expected_error)) }
      end
    end

    context 'when contract params are invalid' do
      let(:options) do
        { req_int: 'string', opt_hash: { req_h_int: 2 } }
      end

      it { expect { subject }.to raise_error { DriedInteractionError } }
    end
  end
end
