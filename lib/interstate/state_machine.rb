module Interstate
  class StateMachine
    attr_reader :states, :context
    attr_accessor :state

    def initialize(object)
      @states = object.class.machine_states
      @state = defined_state(object)
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

    def defined_state(object)
      if object.state.nil?
        object.state = object.class.initialized_state.to_sym
        object.save
      else
        object.state.to_sym
      end
    end
  end
end
