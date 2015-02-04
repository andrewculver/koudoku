module Koudoku
  class WebhooksController < ApplicationController

    def create
      
      raise "API key not configured. For security reasons you must configure this in 'config/koudoku.rb'." unless Koudoku.webhooks_api_key.present?
      raise "Invalid API key. Be sure the webhooks URL Stripe is configured with includes ?api_key= and the correct key." unless params[:api_key] == Koudoku.webhooks_api_key
    
      stripe_id = data_json['data']['object']['customer']
      subscription = ::Subscription.find_by!(stripe_id: stripe_id)

      if payment_succeeded?
        subscription.payment_succeeded(amount)
      elsif charge_failed?
        subscription.charge_failed
      elsif charge_disputed?
        subscription.charge_disputed
      end
      
      render nothing: true
      
    end

    private

    def data_json
      @_data_json ||= JSON.parse(request.body.read)
    end

    def payment_succeeded?
      data_json['type'] == "invoice.payment_succeeded"
    end

    def charge_failed?
      data_json['type'] == "charge.failed"
    end

    def charge_disputed?
      data_json['type'] == "charge.dispute.created"
    end

    def amount
      @_amount ||= data_json['data']['object']['total'].to_f / 100.0
    end

    
  end
end
