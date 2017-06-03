module Interstate
  class StateMachine
    attr_reader :states, :context
    attr_accessor :state

    def initialize(states, state)
      @states = states
      @state = state
    end

    def evaluate_transition_by!(rule)
      @context = rule
      raise failed_transition unless context.from.include? state
    end

    def next
      @state = context.transition_to.first
    end

    def failed_transition
      "can not transit to #{context.transition_to} from #{state} via
        #{context.event}"
    end
  end
end
