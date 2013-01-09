module Koudoku
  class SubscriptionsController < ApplicationController
    before_filter :load_owner
    before_filter :show_existing_subscription, only: [:index, :new, :create]
    before_filter :load_subscription, only: [:show, :cancel, :edit, :update]
    before_filter :load_plans, only: [:index, :edit]
    def load_plans
      @plans = ::Plan.order(:price)
    end
    def load_owner
      # e.g. User.find(params[:user_id])
      @owner = Koudoku.owner_class.find(params[:owner_id])
    end
    def load_subscription
      @subscription = ::Subscription.find(params[:id])
    end
    def index
      # we should also set the owner of the subscription here.
      @subscription = ::Subscription.new({Koudoku.owner_id_sym => @owner.id})
      # e.g. @subscription.user = @owner
      @subscription.send Koudoku.owner_assignment_sym, @owner
    end
    def new
      @subscription = ::Subscription.new
      @subscription.plan = ::Plan.find(params[:plan])
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
    def edit
    end
    def update
      if @subscription.update_attributes(params[:subscription])
        flash[:success] = "You've been successfully upgraded."
        redirect_to owner_subscription_path(@owner, @subscription)
      else
        flash[:error] = 'There was a problem processing this transaction.'
        render :edit
      end
    end
  end
end