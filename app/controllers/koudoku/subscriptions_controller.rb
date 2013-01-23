module Koudoku
  class SubscriptionsController < ApplicationController
    before_filter :load_owner
    before_filter :show_existing_subscription, only: [:index, :new, :create], unless: :no_owner?
    before_filter :load_subscription, only: [:show, :cancel, :edit, :update]
    before_filter :load_plans, only: [:index, :edit]

    def load_plans
      @plans = ::Plan.order(:price)
    end

    def load_owner
      # e.g. User.find(params[:user_id])
      @owner = Koudoku.owner_class.find(params[:owner_id]) unless params[:owner_id].nil?
    end

    def no_owner?
      @owner.nil?
    end

    def load_subscription
      @subscription = ::Subscription.find(params[:id])
    end

    # the following two methods allow us to show the pricing table before someone has an account.
    # by default these support devise, but they can be overriden to support others.
    def current_owner
      # e.g. "self.current_user"
      send "current_#{Koudoku.subscriptions_owned_by.to_s}"
    end

    def redirect_to_sign_up
      session["#{Koudoku.subscriptions_owned_by.to_s}_return_to"] = new_subscription_path(plan: params[:plan])
      redirect_to new_registration_path(Koudoku.subscriptions_owned_by.to_s)
    end

    def index

      # don't bother showing the index if they've already got a subscription.
      if current_owner and current_owner.subscription.present?
        redirect_to koudoku.edit_owner_subscription_path(current_owner, current_owner.subscription)
      end

      # Load all plans.
      @plans = ::Plan.order(:display_order).all
      
      # Don't prep a subscription unless a user is authenticated.
      unless no_owner?
        # we should also set the owner of the subscription here.
        @subscription = ::Subscription.new({Koudoku.owner_id_sym => @owner.id})
        # e.g. @subscription.user = @owner
        @subscription.send Koudoku.owner_assignment_sym, @owner
      end

    end

    def new
      if no_owner?

        if defined?(Devise)

          # by default these methods support devise.
          if current_owner
            redirect_to new_owner_subscription_path(current_owner, plan: params[:plan])
          else
            redirect_to_sign_up
          end
          
        else
          raise "This feature depends on Devise for authentication."
        end

      else
        @subscription = ::Subscription.new
        @subscription.plan = ::Plan.find(params[:plan])
      end
    end

    def show_existing_subscription
      if @owner.subscription.present?
        redirect_to owner_subscription_path(@owner, @owner.subscription)
      end
    end

    def create
      @subscription = ::Subscription.new(params[:subscription])
      @subscription.user = @owner
      if @subscription.save
        flash[:notice] = "You've been successfully upgraded."
        redirect_to owner_subscription_path(@owner, @subscription)
      else
        flash[:error] = 'There was a problem processing this transaction.'
        render :new
      end
    end

    def show
    end

    def cancel
      flash[:notice] = "You've successfully cancelled your subscription."
      @subscription.plan_id = nil
      @subscription.save
      redirect_to owner_subscription_path(@owner, @subscription)
    end

    def edit
    end

    def update
      if @subscription.update_attributes(params[:subscription])
        flash[:notice] = "You've successfully updated your subscription."
        redirect_to owner_subscription_path(@owner, @subscription)
      else
        flash[:error] = 'There was a problem processing this transaction.'
        render :edit
      end
    end

  end
end