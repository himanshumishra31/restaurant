class OrderStock < ApplicationRecord
  belongs_to :branch
  belongs_to :ingredient
  belongs_to :line_item
end
