StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    stripe_id = event.data.object['customer']
      
    subscription = ::Subscription.find_by(stripe_id: stripe_id)
    if subscription.present?
      subscription.charge_failed
    else
      Rails.logger.warn "Received webhook call for stripe charge.failed event but subscription does not exist for stripe ID #{stripe_id}"
    end
  end
  
  events.subscribe 'invoice.payment_succeeded' do |event|
    stripe_id = event.data.object['customer']
    amount = event.data.object['total'].to_f / 100.0
    subscription = ::Subscription.find_by(stripe_id: stripe_id)
    if subscription.present?
      subscription.payment_succeeded(amount)
    else
      Rails.logger.warn "Received webhook call for stripe invoice.payment_succeeded event but subscription does not exist for stripe ID #{stripe_id}"
    end
  end
  
  events.subscribe 'charge.dispute.created' do |event|
    stripe_id = event.data.object['customer']
    subscription = ::Subscription.find_by(stripe_id: stripe_id)
    if subscription.present?
      subscription.charge_disputed
    else
      Rails.logger.warn "Received webhook call for stripe charge.dispute.created event but subscription does not exist for stripe ID #{stripe_id}"
    end
  end
  
  events.subscribe 'customer.subscription.deleted' do |event|
    stripe_id = event.data.object['customer']
    subscription = ::Subscription.find_by(stripe_id: stripe_id)

    if subscription.present?
      subscription.subscription_owner.try(:cancel)
    else
      Rails.logger.warn "Received webhook call for stripe customer.subscription.deleted event but subscription does not exist for stripe ID #{stripe_id}"
    end
  end
end
