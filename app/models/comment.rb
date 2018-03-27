class Comment < ApplicationRecord

  # attribute :body, :paisa, default: 20
  # # ActiveRecord::TypeConflictError: Type money was registered for all adapters, but shadows a native type with the same name for
  # # with money as type

  # attribute :body, :string, default: 'override'
  # # override the previous declaration

  # attribute :check, :integer, default: 10
  # # behaves as dirty

  # attribute :my_int_array, :integer, array: true
  # attribute :my_float_range, :float, range: true


  # currency_converter = ConversionRatesFromTheInternet.new
  # unknown constant ConversionRatesFromTheInternet
  # attribute :price, :paisa, currency_converter: currency_converter



  # # associations
  # # belongs_to :user
  # # belongs_to :inventory

  # # object.attributes gives all the attributes of the object.

  attr_accessor :hi
  attribute_method_affix prefix: 'reset_', suffix: '_to_default!'
  # attribute_method_affix
  # show assign_attributes

  # tell about read attribute
  alias_attribute :newbody, :body
  define_attribute_method :hi
  # define_attribute :body

  def body
    "abcd"
  end

  # p attribute_alias(:newbody)

  private

    def reset_attribute_to_default!(attr)
      send("#{attr}=", 'Default Name')
    end


  scope :today, -> { where(body: 'sub') }

  # validations
  # validates :body, presence: true
end
