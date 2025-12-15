class ShipmentsController < ApplicationController
  before_action :set_subscription, except: [:all, :index_by_user]
  before_action :set_shipment, only: [:show, :edit]
  before_action :authenticate_user!
  before_action :require_admin, except: [:index_by_user, :show]
  def all
    @shipments = Shipment.all
  end

  def index_by_user
    @subscriptions = Subscription
                       .includes(:product)
                       .where(user_id: params[:user_id])
                       .order(created_at: :desc)

    @shipments = Shipment
                   .includes(subscription: :product)
                   .where(subscription_id: @subscriptions.select(:id))
  end

  def new
    @subscriptions = Subscription.all
    @subscription = Subscription.find(params[:subscription_id])
    @shipment = @subscription.shipments.build
  end

  def create
    @subscription = Subscription.find(params[:subscription_id])
    @shipment = @subscription.shipments.build(shipment_params)

    if @shipment.status != 0
      @shipment.shipped_at = Time.now
    end

    if @shipment.save
      redirect_to @subscription, notice: "发货单创建成功"
    else
      render :new
    end
  end

  def show
  end

  def edit

  end

  def update
    @subscription = Subscription.find(params[:subscription_id])
    @shipment = @subscription.shipments.find(params[:id])

    if @shipment.status != 0
      @shipment.shipped_at = Time.now
    end

    if @shipment.update(shipment_params)
      redirect_to subscription_shipment_path(@subscription, @shipment), notice: "发货单更新成功"
    else
      flash.now[:alert] = "更新失败，请检查输入"
      render :edit
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(
      :tracking_number,
      :carrier,
      :status,
      :shipped_at,
      :remark
    )
  end

  def set_subscription
    @subscription = Subscription.find(params[:subscription_id])
  end

  def set_shipment
    @shipment = @subscription.shipments.find(params[:id])
  end
end
