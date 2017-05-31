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

    def on(event:, transition_to: nil, from: nil)
      if block_given?
        yield(event)
        define_method event do
          respond_to?("#{event}_#{state}") ? send("#{event}_#{state}") : raise
          action = Object.const_get(event.to_s.split('_').collect(&:capitalize).join).call(base_object: self)
          if action.success?
            @state_machine.next
          else
            action.error
          end
        end
      else
        define_method event do
          rule = Interactor::Context.new(event: event, transition_to: transition_to, from: from)
          @state_machine.evaluate_transition_by!(rule)
          action = Object.const_get(event.to_s.split('_').collect(&:capitalize).join).call(base_object: self)
          if action.success?
            @state_machine.next
          else
            action.error
          end
        end
      end
    end

    def allow(event: nil, transition_to: nil, from: nil)
      define_method "#{event}_#{from.first}" do
        rule = Interactor::Context.new(event: event, transition_to: transition_to, from: from)
        @state_machine.evaluate_transition_by!(rule)
      end
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

    def states
      state_machine.states
    end
  end
end
