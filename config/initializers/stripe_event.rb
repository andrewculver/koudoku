module CareOfStripeEvents
  def self.handle_failure(failure)
    raise(failure) unless Rails.env.test?

    Rails.logger.warn(failure)
  end

  def self.event_subscription(event)
    stripe_id = event_stripe_id(event)
    subscription = ::Subscription.where(stripe_id: stripe_id).first
    return subscription if subscription

    handle_failure("Unable to find subscription #{stripe_id}")
    nil
  end

  def self.event_stripe_id(event)
    event.data.object['customer']
  end
end

StripeEvent.configure do |events|
  events.all do |event|
    Rails.logger.debug("Received Stripe webhook: #{event}")
    subscription = CareOfStripeEvents.event_subscription(event)

    subscription.update(last_webhook_received_at: Time.zone.now) if subscription
  end

  events.subscribe 'invoice.payment_failed' do |event|
    subscription = CareOfStripeEvents.event_subscription(event)

    if subscription
      subscription.update(last_invoice_payment_failed_at: Time.zone.now)

      Analytics.identify(user_id: subscription.user.id,
                         traits: {
                           stripe_card_last_four: subscription.last_four
                         })
      Analytics.track(user_id: subscription.user.id, event: 'Stripe invoice payment failed')
    end
  end

  # events.subscribe 'charge.failed' do |event|
  #   stripe_id = event.data.object['customer']
  #
  #   subscription = ::Subscription.find_by_stripe_id(stripe_id)
  #   subscription.charge_failed
  # end
  #
  # events.subscribe 'invoice.payment_succeeded' do |event|
  #   stripe_id = event.data.object['customer']
  #   amount = event.data.object['total'].to_f / 100.0
  #   subscription = ::Subscription.find_by_stripe_id(stripe_id)
  #   subscription.payment_succeeded(amount)
  # end
  #
  # events.subscribe 'charge.dispute.created' do |event|
  #   stripe_id = event.data.object['customer']
  #   subscription = ::Subscription.find_by_stripe_id(stripe_id)
  #   subscription.charge_disputed
  # end
  #
  # events.subscribe 'customer.subscription.deleted' do |event|
  #   stripe_id = event.data.object['customer']
  #   subscription = ::Subscription.find_by_stripe_id(stripe_id)
  #   subscription.subscription_owner.try(:cancel)
  # end
end
