require 'interstate_machine'

module PlainRuby
  class Person
    include InterstateMachine
    attr_accessor :state

    initial_state :standing

    transition_table :standing, :running do
      on event: :run do |event|
        allow event: event, transition_to: [:running], from: [:standing]
      end
    end
  end
end
