require 'interstate_machine'
module PlainRuby
  # Naive order checkout
  class Order
    include InterstateMachine
    attr_accessor :state

    initial_state :cart

    transition_table :cart, :payment, :complete do
      on event: :next do |event|
        allow event: event, transition_to: [:payment], from: [:cart]
      end
      on event: :complete, transition_to: [:complete], from: [:payment]
    end
  end
end

class NextPayment
  include Interactor

  before :ensure_line_item

  def call
    # prepare payment model check for profile, default..
  end

  private

  def ensure_line_item
    context.fail! unless context.object.line_items.present?
  end
end

class Complete
  include Interactor

  before :authorize_payment

  def call

  end

  private

  def authorize_payment
    context.gateway_response = Gateway.authorize
    context.fail! unless context.gateway_response[:success?]
  end
end


class Gateway
  def self.authorize; end
end
