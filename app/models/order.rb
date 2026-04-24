class Order < ApplicationRecord
  has_many :linetimes

  def locked?
    return true if locked_at.present?
    created_at < 15.minutes.ago
  end

  def update_line_items(item_params)
    transaction do
      linetimes.where(original: true).update_all(original: false)
      item_params.each do |line|
        linetimes.create!(sku: line[:sku], quantity: line[:quantity], original: true)
      end
      unique_skus = item_params.map { |i| i[:sku] }.uniq
      RecalculateSkuStatsJob.perform_later(unique_skus)
    end
  end
end
