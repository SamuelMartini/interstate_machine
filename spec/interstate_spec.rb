require 'spec_helper'

RSpec.describe InterstateMachine do

  describe '.allow' do
    let(:subject) { Class.include(InterstateMachine) }

    it 'define a method from merging event and from arguments' do
      subject.allow(event: :cycle, transition_to: %i(on), from: %i(off))
      expect(subject).to respond_to(:cycle_off)
    end
  end

  describe '.on' do
    let(:subject) { Class.include(InterstateMachine) }

    context 'when no block is given' do
      it 'define a method from event argument' do
        subject.on(event: :cycle, transition_to: %i(on), from: %i(off))
        expect(subject).to respond_to(:cycle)
      end
    end

    context 'when block is given' do
      let(:subject) { Class.include(InterstateMachine) }
      it 'yield event' do
        subject.on(event: :cycle) do
          subject.allow(event: :cycle, transition_to: %i(on), from: %i(off))
        end
        expect(subject).to respond_to(:cycle_off)
      end
    end
  end
end
