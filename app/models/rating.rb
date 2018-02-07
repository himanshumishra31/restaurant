class Rating < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :meal

  # validations
  # FIX_ME_PG_3:- Lets think this. Should review be in rating model or separate. Or else Rename it to RatingsReview.
  validates :value, :review, presence: true
end
