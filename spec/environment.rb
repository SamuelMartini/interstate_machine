require 'spec_helper'

RSpec.describe InterstateMachine::Environment do
  describe '.define' do
    context 'when active record' do
      let(:base) { ActiveRecord::TrafficLight }
      let(:subject) { described_class }

      before do
        base.included_modules.exclude?(InterstateMachine::ActiveRecordClass::InstanceMethods)
      end
 
      it 'includes ActiveRecordClass::InstanceMethods in base' do
        described_class.define(base)
        expect(base.included_modules).to include(InterstateMachine::ActiveRecordClass::InstanceMethods)
      end
    end

    context 'when plain ruby' do
      let(:base) { PlainRuby::TrafficLight }
      let(:subject) { described_class }

      before do
        base.included_modules.exclude?(PlainRuby::InstanceMethods)
      end

      it 'includes PlainRuby::InstanceMethods in base' do
        described_class.define(base)
        expect(base.included_modules).to include(PlainRuby::InstanceMethods)
      end
    end
  end
end
