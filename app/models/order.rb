class Order < ApplicationRecord
  # assosciations
  belongs_to :cart
  belongs_to :user
  belongs_to :branch
  has_one :charge, dependent: :destroy

  # validations
  validates :phone_number, presence: true
  validates :phone_number, format: { with: /^([9,8,7])(\d{9})$/,  multiline: true }, allow_blank: true
  validates :pick_up, presence: true
  validate :valid_pick_up_time?, if: :pick_up?

  #callbacks
  after_save :send_confirmation_mail

  def valid_pick_up_time?
    unless pick_up.between?(branch.opening_time, branch.closing_time)
      errors.add(:pick_up, " should be between branch timings" )
    end
  end

  def send_confirmation_mail
    OrderMailer.confirmation_mail(self).deliver
  end

  def delivered
    update_columns(picked: !picked)
    feedback_token
    OrderMailer.feedback_mail(self).deliver
  end

  def prepared
    update_columns(ready: !ready)
  end

  def feedback_token
    update_columns(feedback_digest: Order.new_token, feedback_email_sent_at: Time.current)
  end

  def feedback_submitted
    update_attributes(feedback_digest: nil, feedback_email_sent_at: nil)
  end

  def feedback_link_expired?
    feedback_email_sent_at < 1.day.ago
  end

  def cancellable?
    Time.parse(pick_up.strftime("%I:%M%p")) - Time.now > 1800
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def sufficient_stock
    Ingredient.all.each do |ingredient|
      quantity_used = 0
      branch_quantity = branch.inventories.find_by(ingredient_id: ingredient.id).quantity
      cart.line_items.each do |line_item|
        quantity_used += line_item.quantity if line_item.extra_ingredient.eql? ingredient.name
        ingredient_used = line_item.meal.meal_items.find_by(ingredient_id: ingredient.id)
        quantity_used += line_item.quantity * ingredient_used.quantity if ingredient_used
      end
      return false if branch_quantity < quantity_used
    end
    true
  end

  def affect_ingredient(action)
    cart.line_items.each do |line_item|
      meal = Meal.find_by(id: line_item.meal_id)
      meal.meal_items.each do |meal_item|
        branch_inventory = branch.inventories.find_by(ingredient_id: meal_item.ingredient_id)
        branch_inventory.update_columns(quantity: branch_inventory.quantity.send(action.to_sym, (meal_item.quantity * line_item.quantity) ))
      end
    end
  end
end
