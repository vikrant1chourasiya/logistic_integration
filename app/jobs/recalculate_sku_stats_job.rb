class RecalculateSkuStatsJob < ApplicationJob
  queue_as :default

  def perform(skus)
    skus.each do |sku|
      calculate_weekly_stats(sku)
    end
  end

  private
  def calculate_weekly_stats(sku)
    week_start = Time.current.beginning_of_week
    total = Linetime.joins(:orders)
                    .where(sku: sku, original: true)
                    .where("orders.created_at >= ?", week_start)
                    .sum(:quanity)

    stat = SkuStat.find_or_initialize_by(sku: sku, week_start: week_start)
    stat.update(total_quantity: total)
  end
end
