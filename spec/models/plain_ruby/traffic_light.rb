require 'interstate_machine'

module PlainRuby
  class TrafficLight
    include InterstateMachine
    attr_accessor :state

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
