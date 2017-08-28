module InterstateMachine
  module ActiveRecordClass
    module InstanceMethods
      def self.included(base)
        base.after_initialize do |_record|
          @state_machine = StateMachine.new(self)
        end
      end
    end
  end
end
