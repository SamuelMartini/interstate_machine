require "interstate/version"

module Interstate
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def states(*states_list)
      @states = states_list.flatten
    end

    def state_list
      @states ||= []
    end
  end
end
