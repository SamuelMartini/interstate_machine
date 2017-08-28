require 'spec_helper'

RSpec.describe InterstateMachine::StateMachine do

  describe '#new' do
    let(:subject) { described_class.new(object) }
    context 'when active record' do
      let(:object) { ActiveRecord::TrafficLight.new(state: 'wow') }
      it 'define proper accessor' do
        expect(subject.state).to eq :wow
        expect(subject.states).to eq %i(stop proceed caution)
      end
    end

    context 'when plain ruby' do
      let(:object) { PlainRuby::TrafficLight.new }
      it 'define proper accessor' do
        expect(subject.state).to eq :stop
        expect(subject.states).to eq %i(stop proceed caution)
      end
    end
  end

  describe '#evaluate_transition_by!' do
    let(:subject) { described_class.new(object) }
    let(:context) { double('context rule', from: [:stop], transition_to: [:proceed], event: :cycle, object: object) }
    let(:object) { PlainRuby::TrafficLight.new }
    context 'when transition is allowed' do
      it 'returns nothing' do
        expect(subject.evaluate_transition_by!(context)).to be_nil
      end

      it 'assigns context' do
        subject.evaluate_transition_by!(context)
        expect(subject.context).to eq context
      end
    end

    context 'when transition is not allowed' do
      it 'raise an error' do
        object.state = 'wrong'
        expect { subject.evaluate_transition_by!(context) }.to raise_error(RuntimeError)
      end
    end
  end
end
