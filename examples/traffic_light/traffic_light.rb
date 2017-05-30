require 'interstate'
require_relative 'cycle'

class TrafficLight
  include Interstate

  initial_state :stop

  transition_table :stop, :proceed, :caution do
    on event: :cycle do |event|
      allow event: event, transition_to: [:proceed], from: [:stop]
      allow event: event, transition_to: [:caution], from: [:proceed]
      allow event: event, transition_to: [:stop], from: [:caution]
    end
  end
end
