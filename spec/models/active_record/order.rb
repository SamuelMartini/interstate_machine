require 'interstate_machine'

require 'byebug'
module ActiveRecord
  class Order < ActiveRecord::Base
    include InterstateMachine

    initial_state :cart

    transition_table :cart, :address, :delivery, :payment, :confirm, :completed do
      on event: :next do |event|
        allow event: event, transition_to: [:address], from: [:cart]
        allow event: event, transition_to: [:delivery], from: [:address]
        allow event: event, transition_to: [:payment], from: [:delivery]
        allow event: event, transition_to: [:confirm], from: [:payment]
      end
      on event: :complete, transition_to: [:completed], from: [:confirm]
    end
  end
end

class NextAddress
  include Interactor

  before :validate_transition

  def call
    # if address already stored populate
  end

  private

  def validate_transition
    # We check line items presence
    return if context.object.line_items.present?
    context.object.errors.add(:base, 'no line items for this order')
    context.fail!(error: 'no line items for this order')
  end
end

class NextDelivery
  include Interactor

  before :validate_transition

  def call
    # calculate shipment
  end

  private

  def validate_transition
    # We check address presence and checks
    if context.object.address.blank?
      context.object.errors.add(:base, 'no address for this order')
      context.fail!(error: 'no address for this order')
    end
    if context.object.address.include? 'Death Star'
      context.object.errors.add(:base, "we do not  ship to #{context.object.address}")
      context.fail!(error: "we do not  ship to #{context.object.address}")
    end
  end
end

class NextPayment
  include Interactor

  before :prepare_totals

  def call
    # prepare payment model check for profile, default..
  end

  private

  def prepare_totals
    # sum line items, shipments..
  end
end

class NextConfirm
  include Interactor

  around :authorize_payment
  before :validate_transition
  def call
    context.object.payment_state = context.gateway_response
  end

  private

  def authorize_payment(interactor)
    context.gateway_response = Gateway.authorize
    interactor.call
    validate_transition
  end

  def validate_transition
    return if context.object.payment_state != 'failed'
    context.object.errors.add(:base, 'payment not authorized')
    context.fail!(error: 'payment not authorized')
  end
end

class Complete
  include Interactor

  def call
    # finalize checkout
  end
end

class Gateway
  def self.authorize; end
end
