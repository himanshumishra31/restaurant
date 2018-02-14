class Rating < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :meal

  # validations
  validates :value, :review, presence: true

  def create_rating(value, review)
    self.value = value
    self.review = review
    save!
  end
end
