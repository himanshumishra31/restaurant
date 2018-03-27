# class MoneyType < ActiveRecord::Type::Integer
#   def cast(value)
#     if !value.kind_of?(Numeric) && value.include?('$')
#       price_in_dollars = value.gsub(/\$/, '').to_f
#       super(price_in_dollars * 100)
#     else
#       super
#     end
#   end
# end


# class Money < Struct.new(:amount, :currency)
# end

# class MoneyType < Type::Value
#   def initialize(currency_converter:)
#     @currency_converter = currency_converter
#   end

#   # value will be the result of +deserialize+ or
#   # +cast+. Assumed to be an instance of +Money+ in
#   # this case.
#   def serialize(value)
#     value_in_bitcoins = @currency_converter.convert_to_bitcoins(value)
#     value_in_bitcoins.amount
#   end
# end

# ActiveRecord::Type.register(:paisa, MoneyType)
