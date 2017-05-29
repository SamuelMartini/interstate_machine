require "interstate/version"
require "interstate/state_machine"
require 'interactor'

module Interstate
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end

    attr_reader :state_machine
  end

  module ClassMethods
    def initial_state(state)
      @initialized_state = state
    end

    def initialized_state
      @initialized_state ||= []
    end

    def machine_states
      @machine_states ||= []
    end

    def transition_table(*states)
      @machine_states = states
      yield
    end
  end

  module InstanceMethods
    def initialize
      @state_machine = StateMachine.new(self.class.machine_states,
                                        self.class.initialized_state)
    end

    def state
      state_machine.state
    end
  end
end
