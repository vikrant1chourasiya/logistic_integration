class SkuSummaryController < ApplicationController
  def show
    sku_code = params[:sku]
    stats = SkuStat.for_sku(sku_code)

    if stats.exists?
      render json: { sku: sku_code, history: stats.map { |s| { week: s.week_label, total_quantity: s.total_quantity } } }, status: :ok
    else
      render json: { error: "NotFound", message: "No stats found for SKU #{sku_code}" }, status: :not_found
    end
  end
end
