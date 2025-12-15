class SubscriptionsController < ApplicationController
  before_action :require_admin, except: [:index_by_user, :new, :show, :create, :unsubscribe]
  before_action :set_subscription, only: [:show, :destroy]
  before_action :authenticate_user!
  def index
    @subscriptions = Subscription.includes(:product, :user).all.order(created_at: :desc)

    if params[:status].present? && Subscription.statuses.keys.include?(params[:status])
      @subscriptions = @subscriptions.where(status: params[:status])
    end

    if params[:q].present?
      query = "%#{params[:q].downcase}%"
      @subscriptions = @subscriptions.joins(:product, :user).where(
        "LOWER(products.name) LIKE :query OR LOWER(users.email) LIKE :query", query: query
      )
    end
  end

  def show
    @shipments = @subscription.shipments
  end

  def new
    @subscription = Subscription.new(
      product_id: params[:product_id]
    )
    @products = Product.order(:name)
  end

  def create
    @products = Product.all.order(:name)

    product = Product.find(subscription_params[:product_id])

    @subscription = Subscriptions::CreateService.new(
      user: current_user,
      product: product,
      quantity: subscription_params[:quantity]
    ).call

    redirect_to product_path(@subscription.product), notice: "订购成功"
  rescue ActiveRecord::RecordInvalid => e
    @subscription ||= current_user.subscriptions.build(subscription_params)
    render :new
  end

  def unsubscribe
    @subscription = Subscription.find(params[:subscription_id])
    Subscriptions::CancelService.new(subscription: @subscription).call
    if current_user.is_admin
      redirect_to subscriptions_path
    else
      redirect_to user_subscriptions_path(current_user)
    end
  end

  def destroy
    puts @subscription.id
  end

  def index_by_user
    puts params[:user_id]
    @subscriptions = Subscription.includes(:product, :user).where(user: current_user).order(created_at: :desc)

    if params[:status].present? && Subscription.statuses.keys.include?(params[:status])
      @subscriptions = @subscriptions.where(status: params[:status])
    end

    if params[:q].present?
      query = "%#{params[:q].downcase}%"
      @subscriptions = @subscriptions.joins(:product, :user).where(
        "LOWER(products.name) LIKE :query OR LOWER(users.email) LIKE :query", query: query
      )
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:product_id, :quantity)
  end

end
