require 'interstate/version'
require 'interstate/state_machine'
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
      yield(event) if block_given?
      perform_transition_by(
        event: event,
        transition_to: transition_to,
        from: from
      )
    end

    def allow(event: nil, transition_to: nil, from: nil)
      define_method "#{event}_#{from.first}" do
        ensure_can_transit(event, transition_to, from)
      end
    end

    private

    def perform_transition_by(event: nil, transition_to: nil, from: nil)
      define_method event do
        evaluate_transition(event, transition_to, from)
        action = constantize(event).call(base_object: self)
        action.success? ? @state_machine.next : action.error
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

    private

    def evaluate_transition(event, transition_to, from)
      if event_with_multiple_state_transition?(event, transition_to, from)
        send("#{event}_#{state}")
      elsif event_with_single_state_transition?(event, transition_to, from)
        ensure_can_transit(event, transition_to, from)
      else
        raise "cannot transition via #{event} from #{state}"
      end
    end

    def ensure_can_transit(event, transition_to, from)
      @state_machine.evaluate_transition_by!(
        Interactor::Context.new(
          event: event, transition_to: transition_to, from: from
        )
      )
    end

    def event_with_single_state_transition?(event, transition_to, from)
      respond_to?(event) && transition_to && from
    end

    def event_with_multiple_state_transition?(event, _transition_to, _from)
      respond_to?("#{event}_#{state}")
    end

    def constantize(event)
      Object.const_get(event.to_s.split('_').collect(&:capitalize).join)
    end
  end
end
