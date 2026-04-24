class SkuStat < ApplicationRecord
  validates :sku, presence: true
  validates :week_start, presence: true

  def week_label
    "#(week_start.year)-W#{week_start.strftime('%V')}"
  end

  scopes :for_sku, ->(sku) { where(sku: sku) }.order(week_start: :desc)
end
