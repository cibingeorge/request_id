# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

describe Sidekiq::Middleware::Client::RequestId do
  let(:middleware) { described_class.new }

  describe '#call' do
    context 'when the worker is an object that responds to `get_sidekiq_options`' do
      let(:worker) { double('worker', to_s: 'Worker') }

      context 'when the worker is configured to log request ids' do
        it 'adds the request id to the item' do
          request_id = Thread.current[:request_id] = SecureRandom.hex
          item = {}
          expect { middleware.call(worker, item, nil) {} }.to change { item }.from({}).to('request_id' => request_id)
        end
      end

      context 'when there is a retry enqueued by sidekiq' do
        it 'does not overwrite the existing request id with nil' do
          Thread.current[:request_id] = nil
          request_id = SecureRandom.hex
          item = { 'request_id' => request_id }
          expect { middleware.call(worker, item, nil) {} }.not_to change { item }
        end
      end

      context 'when the worker is not configured to log request ids' do
        before { allow(worker).to receive(:get_sidekiq_options).and_return({}) }

        it 'does not log the request' do
          expect { |b| middleware.call(worker, {}, nil, &b) }.to yield_control
        end
      end
    end

    context 'when the worker is an object that does not respond to `get_sidekiq_options`' do
      let(:worker) { 'Worker' }

      it 'does not log the request' do
        expect { |b| middleware.call(worker, {}, nil, &b) }.to yield_control
      end
    end
  end
end
