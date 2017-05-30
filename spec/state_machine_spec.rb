require 'spec_helper'

RSpec.describe Interstate::StateMachine do
  let(:state_machine) { described_class.new([:on, :off], state)}
  let(:state) { :off }
  describe '#evaluate_transition_by!' do
    let(:context) { double('rule context', from:[:off], transition_to: [:on], event: :cycle) }

    context 'when transition is allowed' do
      it 'returns nothing' do
        expect(state_machine.evaluate_transition_by!(context)).to be_nil
      end
    end

    context 'when transition is not allowed' do
      let(:state) { :no_state }
      it 'raise an error' do
        expect{ state_machine.evaluate_transition_by!(context) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#next' do
    let(:context) { double('rule context', from:[:off], transition_to: [:on], event: :cycle) }
    before { state_machine.instance_variable_set(:@context, context) }
    it 'sets state to next state transition' do
      expect(state_machine.next).to eq :on
    end
  end
end
