module ActiveRecord
  class Vehicle < ActiveRecord::Base
    include InterstateMachine

    initial_state :parked

    transition_table :parked, :idling, :first_gear, :second_gear, :third_gear, :stalled do
      on event: :park, transition_to: [:parked], from: [:idling, :first_gear]
      on event: :ignite, transition_to: [:idling], from: [:parked]
      on event: :idle, transition_to: [:idling], from: [:first_gear]
      on event: :shift_up do |event|
        allow event: event, transition_to: [:first_gear], from: [:idling]
        allow event: event, transition_to: [:second_gear], from: [:first_gear]
        allow event: event, transition_to: [:third_gear], from: [:second_gear]
      end
      on event: :shift_down do |event|
        allow event: event, transition_to: [:second_gear], from: [:third_gear]
        allow event: event, transition_to: [:first_gear], from: [:second_gear]
      end
      on event: :crash, transition_to: [:stalled], from: [:first_gear, :second_gear, :third_gear]
      on event: :repair, transition_to: [:parked], from: [:stalled]
    end
  end
end
class Park
  include Interactor

  def call; end
end
class Ignite
  include Interactor

  def call; end
end
class Idle
  include Interactor

  def call; end
end
class ShiftUp
  include Interactor

  def call; end
end
class ShiftUpFirstGear
  include Interactor

  def call; end
end
class ShiftUpSecondGear
  include Interactor

  def call; end
end
class ShiftUpThirdGear
  include Interactor

  def call; end
end
class ShiftDown
  include Interactor

  def call; end
end
class ShiftDownFirstGear
  include Interactor

  def call; end
end
class ShiftDownSecondGear
  include Interactor

  def call; end
end
class Crash
  include Interactor

  def call; end
end
class Repair
  include Interactor

  def call; end
end
