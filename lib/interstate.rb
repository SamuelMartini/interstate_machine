require 'interstate/version'
require 'interstate/state_machine'
require 'interstate/environment'
require 'interstate/base/instance_methods'
require 'interstate/plain_ruby/instance_methods'

require 'interstate/active_record_class/instance_methods'
require 'interactor'

module Interstate
  def self.included(base)
    base.class_eval do
      Environment.define(base)
      include Base::InstanceMethods
      extend ClassMethods

      private
      attr_reader :state_machine
    end
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
        ensure_can_transit(event, transition_to, from, multiple: true)
      end
    end

    private

    def perform_transition_by(event: nil, transition_to: nil, from: nil)
      define_method event do
        evaluate_transition(event, transition_to, from)
        action = constantize(interactor_name(event)).call(object: self)
        action.success? ? @state_machine.next : action.error
      end
    end
  end
end
