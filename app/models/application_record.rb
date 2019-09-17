class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def error_message(message, model_name, attribute_name)
    I18n.t(message, scope: [:activerecord, :errors, :models, model_name, :attributes, attribute_name])
  end
end
