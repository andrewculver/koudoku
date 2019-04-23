module Koudoku
  class SubscriptionsController < ApplicationController
    before_action :load_owner
    before_action :show_existing_subscription, only: [:index, :new, :create], unless: :no_owner?
    before_action :load_subscription, only: [:show, :cancel, :edit, :update]
    before_action :load_plans, only: [:index, :edit]

    def load_plans
      @plans = ::Plan.order(:display_order)
    end

    def unauthorized
      render status: 401, template: "koudoku/subscriptions/unauthorized"
      false
    end

    def load_owner
      unless params[:owner_id].nil?
        if current_owner.present?

          # we need to try and look this owner up via the find method so that we're
          # taking advantage of any override of the find method that would be provided
          # by older versions of friendly_id. (support for newer versions default behavior
          # below.)

          searched_owner = current_owner.class.find(params[:owner_id]) rescue nil

          # if we couldn't find them that way, check whether there is a new version of
          # friendly_id in place that we can use to look them up by their slug.
          # in christoph's words, "why?!" in my words, "warum?!!!"
          # (we debugged this together on skype.)
          if searched_owner.nil? && current_owner.class.respond_to?(:friendly)
            searched_owner = current_owner.class.friendly.find(params[:owner_id]) rescue nil
          end

          if current_owner.try(:id) == searched_owner.try(:id)
            @owner = current_owner
          else
            return unauthorized
          end
        else
          return unauthorized
        end
      end
    end

    def no_owner?
      @owner.nil?
    end

    def load_subscription
      ownership_attribute = :"#{Koudoku.subscriptions_owned_by}_id"
      @subscription = ::Subscription.where(ownership_attribute => current_owner.id).find_by_id(params[:id])

      # also, if cancan methods are available, we should use that to authorize.
      if respond_to?(:can?)
        return unauthorized unless can? :manage, @subscription
      end

      return @subscription.present? ? @subscription : unauthorized
    end

    # the following three methods allow us to show the pricing table before someone has an account.
    # by default these support devise, but they can be overriden to support others.
    def current_owner
      # e.g. "self.current_user"
      send "current_#{Koudoku.subscriptions_owned_by}"
    end

    def current_owned_through_or_by
      # e.g. "self.current_user"
      send "current_#{Koudoku.subscriptions_owned_through_or_by}"
    end

    def redirect_to_sign_up
      # this is a Devise default variable and thus should not change its name
      # when we change subscription owners from :user to :company
      session["#{Koudoku.subscriptions_owned_through_or_by}_return_to"] = new_subscription_path(plan: params[:plan])
      redirect_to new_registration_path(Koudoku.subscriptions_owned_through_or_by.to_s)
    end

    def index

      # don't bother showing the index if they've already got a subscription.
      if current_owner and current_owner.subscription.present?
        redirect_to koudoku.edit_owner_subscription_path(current_owner, current_owner.subscription)
      end

      # Don't prep a subscription unless a user is authenticated.
      unless no_owner?
        # we should also set the owner of the subscription here.
        @subscription = ::Subscription.new({Koudoku.owner_id_sym => @owner.id})
        @subscription.subscription_owner = @owner
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
          raise I18n.t('koudoku.failure.feature_depends_on_devise')
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

      @subscription = ::Subscription.new(subscription_params)
      @subscription.subscription_owner = @owner
      @subscription.coupon_code = session[:koudoku_coupon_code]

      if @subscription.save
        flash[:notice] = after_new_subscription_message
        redirect_to after_new_subscription_path
      else
        flash[:error] = I18n.t('koudoku.failure.problem_processing_transaction')
        render :new
      end
    end

    def show
    end

    def cancel
      flash[:notice] = I18n.t('koudoku.confirmations.subscription_cancelled')
      @subscription.plan_id = nil
      @subscription.save
      redirect_to owner_subscription_path(@owner, @subscription)
    end

    def edit
    end

    def update
      if @subscription.update_attributes(subscription_params)
        flash[:notice] = I18n.t('koudoku.confirmations.subscription_updated')
        redirect_to owner_subscription_path(@owner, @subscription)
      else
        flash[:error] = I18n.t('koudoku.failure.problem_processing_transaction')
        render :edit
      end
    end

    private
    def subscription_params

      # If strong_parameters is around, use that.
      if defined?(ActionController::StrongParameters)
        params.require(:subscription).permit(:plan_id, :stripe_id, :current_price, :credit_card_token, :card_type, :last_four)
      else
        # Otherwise, let's hope they're using attr_accessible to protect their models!
        params[:subscription]
      end

    end

    def after_new_subscription_path
      return super(@owner, @subscription) if defined?(super)
      owner_subscription_path(@owner, @subscription)
    end

    def after_new_subscription_message
      controller = ::ApplicationController.new
      controller.respond_to?(:new_subscription_notice_message) ?
          controller.try(:new_subscription_notice_message) :
          I18n.t('koudoku.confirmations.subscription_upgraded')
    end
  end
end
