module Interstate
  class StateMachine
    def initialize(states, initialized_state)
      @states = states
      @current_state = initialized_state
    end

    attr_accessor :current_state
  end
end
