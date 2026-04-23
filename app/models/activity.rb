class Activity < ApplicationRecord
  validates :title, :event_date, presence: true
  scope :upcoming, -> { where("event_date >= ?", Date.today).order(event_date: :asc) }
end
