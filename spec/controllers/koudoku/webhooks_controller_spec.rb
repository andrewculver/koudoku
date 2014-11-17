require 'spec_helper'

describe Koudoku::WebhooksController do

  before do
    # disable any interaction with stripe for these tests.
    allow_any_instance_of(Subscription).to receive(:processing!) { true }
  end
      
  describe "POST create" do

    let(:customer_id) { subscription.stripe_id }
    let(:api_key) { Koudoku.webhooks_api_key }

    def create_webhooks(opts={})
      raw_post(
        :create,
        { use_route: 'koudoku', api_key: api_key },
        webhooks_json(event_type, total: '1234', customer: customer_id)
      )
    end
  
    describe 'when a valid subscription exists' do

      # here is the corresponding customer in our database.
      let!(:customer) { Customer.create!(email: 'andrew.culver@gmail.com') }
      let!(:subscription) { 
        Subscription.create!(customer_id: customer.id, stripe_id: 'customer-id')
      }

      before do
        original_method = Subscription.method(:find_by!)
        allow(Subscription).to receive 'find_by!' do |hash|
          if hash[:stripe_id] == subscription.stripe_id
            # Make sure we get this exact instance, so we can set expectations
            subscription
          else
            original_method.call(*args)
          end
        end
      end
      
      describe "when type is invoice.payment_succeeded" do
        let(:event_type) { "invoice.payment_succeeded" }

        it 'calls payment_succeeded for the subscription' do
          expect(subscription).to receive(:payment_succeeded).once
          create_webhooks
        end

        it 'returns 200' do
          create_webhooks
          expect(response.code).to eq("200") 
        end
      end


      describe "when type is charge.failed" do
        let(:event_type) { "charge.failed" }

        it 'calls charge_failed for the subscription' do
          expect(subscription).to receive(:charge_failed).once
          create_webhooks
        end

        it 'returns 200' do
          expect(response.code).to eq("200") 
        end
      end


      describe "when type is charge.dispute.created" do
        let(:event_type) { "charge.dispute.created" }

        it 'calls charge_disputed for the subscription' do
          expect(subscription).to receive(:charge_disputed).once
          create_webhooks
        end

        it 'returns 200' do
          create_webhooks
          expect(response.code).to eq("200") 
        end
      end


      describe "when type is something else" do
        let(:event_type) { "resource.something_else" }

        describe "when the API key is invalid" do
          let(:api_key) { "not-the-api-key" }

          it "raises an error" do
            expect{create_webhooks}.to raise_error
          end
        end

        describe "when the API key is valid" do
          it "does not raise an error" do
            expect{create_webhooks}.to_not raise_error
          end
        end
      end
    end

    describe "when the subscription can not be found" do
      let(:customer_id) { "some-random-id" }
      let(:event_type) { "invoice.payment_succeeded" }
      it "raises an error" do
        expect{create_webhooks}.to raise_error
      end
    end

  end
end
