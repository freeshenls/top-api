class Site < ApplicationRecord
  belongs_to :category
  has_one_attached :icon_image
end
