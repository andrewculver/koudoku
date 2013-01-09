module Koudoku
  class SubscriptionsController < ApplicationController
    before_filter :load_owner
    before_filter :show_existing_subscription, only: [:index, :new, :create]
    before_filter :load_subscription, only: [:show, :cancel]
    def load_owner
      # e.g. User.find(params[:user_id])
      @owner = Koudoku.owner_class.find(params[:owner_id])
    end
    def load_subscription
      @subscription = ::Subscription.find(params[:id])
    end
    def index
      @plans = Plan.order(:price)
    end
    def new
      @subscription = ::Subscription.new
      @subscription.plan = Plan.find(params[:plan])
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
        flash[:success] = "You've been successfully upgraded."
        redirect_to owner_subscription_path(@owner, @subscription)
      else
        flash[:error] = 'There was a problem processing this transaction.'
        render :new
      end
    end
    def show
    end
    def cancel
      flash[:success] = "You've successfully cancelled your subscription."
      @subscription.plan_id = nil
      @subscription.save
      redirect_to owner_subscription_path(@owner, @subscription)
    end
  end
end