module PlainRuby
  module InstanceMethods
    attr_accessor :state_machine

    def initialize
      super
      @state_machine = InterstateMachine::StateMachine.new(self)
    end

    def save
    end
  end
end
