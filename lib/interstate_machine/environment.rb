module InterstateMachine
  class Environment

    def self.define(base)
      if active_record?(base)
        base.send(:include, ActiveRecordClass::InstanceMethods)
      else
        base.send(:prepend, PlainRuby::InstanceMethods)
      end
    end

    def self.active_record?(base)
      base.ancestors.include?(ActiveRecord::Base) rescue false
    end
  end
end
