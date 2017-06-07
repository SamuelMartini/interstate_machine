module Interstate
  class Plain
    def initialize
      @state_machine = StateMachine.new(self.class.machine_states,
                                        self.class.initialized_state)
    end

    def state
      state_machine.state
    end

    def state=(sym)
      state_machine.state = sym
    end
  end
end
