module ActiveRecord
  class TrafficLight < ActiveRecord::Base
    include InterstateMachine

    initial_state :stop

    transition_table :stop, :proceed, :caution do
      on event: :cycle do |event|
        allow event: event, transition_to: [:proceed], from: [:stop]
        allow event: event, transition_to: [:caution], from: [:proceed]
        allow event: event, transition_to: [:stop], from: [:caution]
      end
    end
  end
end
