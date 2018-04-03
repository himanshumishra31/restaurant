class Order < ApplicationRecord
  TIME_FORMAT = "%I:%M%p"
  PREPARATION_TIME = 1800
  include TokenGenerator

  delegate :name, to: :branch, prefix: true
  delegate :address, to: :branch, prefix: true
  delegate :contact_number, to: :branch, prefix: true

  # associations
  belongs_to :cart
  belongs_to :user
  belongs_to :branch
  has_one :charge, dependent: :destroy

  # validations
  validates :phone_number, presence: true
  validates :phone_number, format: { with: PHONE_NUMBER_VALIDATION_REGEX,  multiline: true }, allow_blank: true
  validates :pick_up, presence: true
  validate :valid_pick_up_time?, if: :pick_up?
  validate :sufficient_preparation_time?, if: :pick_up?
  validate :past_pick_up?, if: :pick_up?

  #callbacks
  after_create_commit :send_confirmation_mail

  scope :by_date, -> (from = 7.days.ago, to = Time.current) { where created_at: from..to }

  def delivered
    toggle!(:picked)
    feedback_token
    OrderMailer.feedback_mail(self).deliver_later
  end

  def prepared
    toggle!(:ready)
  end

  def self.most_sold_meal(orders)
    cart_ids = orders.pluck(:cart_id)
    line_items = LineItem.where(cart_id: cart_ids)
    meal_sold = line_items.select(:meal_id, :quantity).group_by(&:meal_id)
    meal_sold_with_quantity = meal_sold.each { |id, ls| meal_sold[id] = ls.pluck(:quantity).sum }
    meal_sold_with_quantity.key(meal_sold_with_quantity.values.max)
  end

  def feedback_submitted
    update_attributes(feedback_digest: nil, feedback_email_sent_at: nil)
  end

  def feedback_link_expired?
    feedback_email_sent_at < 1.day.ago
  end

  def cancellable?
    Time.parse(pick_up.strftime(TIME_FORMAT)) - Time.current > PREPARATION_TIME
  end

  def sufficient_stock
    Ingredient.all.each do |ingredient|
      quantity_used = 0
      branch_quantity = branch.inventories.find_by(ingredient_id: ingredient.id).try(:quantity) || 0
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
        branch_inventory.update_columns(quantity: branch_inventory.quantity.send(action.to_sym, (meal_item.quantity * line_item.quantity) )) if branch_inventory
      end
    end
  end

  private

    def sufficient_preparation_time?
      if Time.parse(pick_up.strftime(TIME_FORMAT)) - Time.current < PREPARATION_TIME
        errors.add(:pick_up, error_message('insufficient_time', :order, :pick_up))
      end
    end

    def past_pick_up?
      if Time.current > Time.parse(pick_up.strftime(TIME_FORMAT))
        errors.add(:pick_up, error_message('invalid', :order, :pick_up))
      end
    end

    def valid_pick_up_time?
      unless pick_up.between?(branch.opening_time, branch.closing_time)
        errors.add(:pick_up, error_message('invalid_timings', :order, :pick_up) )
      end
    end

    def send_confirmation_mail
      OrderMailer.confirmation_mail(self).deliver_later
    end

    def feedback_token
      update_columns(feedback_digest: generate_token, feedback_email_sent_at: Time.current)
    end
end
