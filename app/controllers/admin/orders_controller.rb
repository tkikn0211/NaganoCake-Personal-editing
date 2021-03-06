class Admin::OrdersController < ApplicationController
 before_action :authenticate_admin!
 
 def index
  @orders = Order.all.order(created_at: :desc).page(params[:page]).per(10)
 end

 def show
  @order = Order.find(params[:id])
  @order_details = @order.order_details
 end

 def update
  @order = Order.find(params[:id])
  @order_details = @order.order_details
   if @order.update(order_params)
    if params[:order][:status] == "payment_confirmation"
     @order_details.each do |order_detail|
       order_detail.making_status = "wait"
       order_detail.save
     end
    end
    flash[:notice] = "注文ステータスの更新に成功しました"
    redirect_to admin_order_path(@order)
   else
    render :show
   end
 end

 private

 def order_params
   params.require(:order).permit(:status)
 end

end
