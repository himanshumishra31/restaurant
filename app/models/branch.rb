class Branch < ApplicationRecord
  # validations
  validates :name, :opening_time, :closing_time, presence: true
  validates :name, uniqueness: true
  validate :opening_time_should_be_before_closing_time

  def opening_time_should_be_before_closing_time
    errors.add(:opening_time, "should be before closing time") if closing_time - opening_time < 0
  end
end
