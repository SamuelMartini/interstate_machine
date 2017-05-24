require 'interstate'
require_relative 'order_cart'

class Order
  states OrderCart
end
