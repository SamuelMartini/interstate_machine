module PlainRuby
  module InstanceMethods
    attr_accessor :state_machine

    def initialize
      @state_machine = Interstate::StateMachine.new(self)
    end

    def save
    end
  end
end
