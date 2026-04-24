class OrdersController < ApplicationController
  def create
    @order = Order.find_or_initialize_by(external_id: params[:external_id])

    if @order.persisted?
      if @order.locked?
        render json: { error: "LockedForEdit", message: "Order cannot be modified" }, status: :unprocessable_entity
        return
      end
    else
      @order.placed_at = order_params[:placed_at]
      @order.save!
    end

    @order.update_line_items(order_params[:linetimes_attributes])
    render json: { message: "Order processed successfully", id: @order.id }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: :bad_request
    end
  end

  private
  def order_params
    params.require(:order).permit(:external_id, :placed_at, linetimes_attributes: [:sku, :quantity])
  end
end
