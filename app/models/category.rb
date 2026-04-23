class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :sites, -> { order(position: :asc) }, dependent: :destroy
  
  validates :name, presence: true
  
  scope :roots, -> { where(parent_id: nil, active: true).order(position: :asc) }
  scope :active, -> { where(active: true).order(position: :asc) }
end
