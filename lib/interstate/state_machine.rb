module Interstate
  class StateMachine
    def initialize(states, state)
      @states = states
      @state = state
    end

    attr_accessor :current_state, :states, :state
  end
end
