class Comment < ApplicationRecord

  # associations
  belongs_to :user
  belongs_to :inventory

  # validations
  validates :body, presence: true
end
