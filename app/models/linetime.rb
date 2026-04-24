class Linetime < ApplicationRecord
  belongs_to :orders, dependent: :destroy
end
