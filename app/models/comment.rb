class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :inventory
  validates :body, presence: true
end
