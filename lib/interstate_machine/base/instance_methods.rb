module InterstateMachine
  module Base
    module InstanceMethods

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

      def ensure_can_transit(event, transition_to, from, multiple: false)
        @state_machine.evaluate_transition_by!(
          Interactor::Context.new(
            event: event, transition_to: transition_to, from: from,
            multiple: multiple, object: self
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

      def interactor_name(event)
        if state_machine.context.multiple
          "#{event}_#{state_machine.next_state}"
        else
          event
        end
      end
    end
  end
end
