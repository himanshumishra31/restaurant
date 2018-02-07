class Comment < ApplicationRecord

  # associations
  belongs_to :user
  belongs_to :inventory

  # validations
  validates :body, presence: true
end

#FIX_ME:- Lets think of better architecture for commenting on inventory.