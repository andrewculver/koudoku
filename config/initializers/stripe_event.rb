StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    stripe_id = event.data.object['customer']
      
    subscription = ::Subscription.find_by_stripe_id(stripe_id)
    subscription.charge_failed
  end
  
  events.subscribe 'invoice.payment_succeeded' do |event|
    stripe_id = event.data.object['customer']
    amount = event.data.object['total'].to_f / 100.0
    subscription = ::Subscription.find_by_stripe_id(stripe_id)
    subscription.payment_succeeded(amount)
  end
  
  events.subscribe 'charge.dispute.created' do |event|
    stripe_id = event.data.object['customer']
    subscription = ::Subscription.find_by_stripe_id(stripe_id)
    subscription.charge_disputed
  end
  
  events.subscribe 'customer.subscription.deleted' do |event|
    stripe_id = event.data.object['customer']
    subscription = ::Subscription.find_by_stripe_id(stripe_id)
    subscription.subscription_owner.try(:cancel)
  end
end