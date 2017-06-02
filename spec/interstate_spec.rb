require 'spec_helper'

RSpec.describe Interstate do
  class Run
    def call; end
  end

  class Cycle
    def call; end
  end

  let(:interstate) { Class.new.send(:include, described_class) }

  describe '.new' do
    let(:subject) { interstate.new }

    it 'instantiates a state machine' do
      expect(subject.state_machine).to be_instance_of Interstate::StateMachine
    end
  end

  describe '#state' do
    it 'returns the current state' do
      interstate.initial_state(:on)
      instance = interstate.new
      expect(instance.state).to eq :on
    end
  end

  describe '#states' do
    it 'returns all states' do
      interstate.transition_table(:off, :on) {}
      instance = interstate.new
      expect(instance.states).to eq [:off, :on]
    end
  end


  describe '.allow' do
    before do
      allow_any_instance_of(Interstate::StateMachine).to receive(:evaluate_transition_by!)
      interstate.allow(event: :run, transition_to: [:running] , from: [:standing])
    end

    let(:subject) { interstate.new }

    it 'define a method from merging event and from arguments' do
      expect(subject).to respond_to(:run_standing)
    end

    it 'creates a context rules' do
      allow(Interactor::Context).to receive(:new).with(event: :run, transition_to: [:running] , from: [:standing])
      subject.run_standing
      expect(Interactor::Context).to have_received(:new).with(event: :run, transition_to: [:running] , from: [:standing])
    end

    it 'evaluates the transition throught state machine' do
      expect_any_instance_of(Interstate::StateMachine).to receive(:evaluate_transition_by!)
      subject.run_standing
    end
  end

  describe '.on' do
    let(:subject) { interstate.new }
    before do
      allow_any_instance_of(Interstate::StateMachine).to receive(:evaluate_transition_by!)
      allow_any_instance_of(Interstate::StateMachine).to receive(:next) { 'next state'}
    end
    context 'when no block is given' do
      let(:context) { double('event context', success?: true) }
      before do
        allow(Run).to receive(:call).with(base_object: subject) { context }
        interstate.on(event: :run, transition_to: [:running] , from: [:standing])
      end

      it 'define a method from event argument' do
        expect(subject).to respond_to(:run)
      end

      context 'when evaluating the transition' do
        before do
          expect(Run).to receive(:call).with(base_object: subject)
        end
        context 'and event is successfull' do
          it 'sends next to state machine' do
            expect_any_instance_of(Interstate::StateMachine).to receive(:next)
            subject.run
          end
        end

        context 'and event is no successfull' do
          let(:context) { double('event context', success?: false, error: 'error') }

          it 'does not sends next to state machine' do
            expect_any_instance_of(Interstate::StateMachine).to_not receive(:next)
            subject.run
          end
        end
      end

      it 'evaluates the transition throught state machine' do
        expect_any_instance_of(Interstate::StateMachine).to receive(:evaluate_transition_by!)
        subject.run
      end

      it 'call an event interactor' do
        allow(Interactor::Context).to receive(:new).with(event: :run, transition_to: [:running] , from: [:standing])
        subject.run
        expect(Interactor::Context).to have_received(:new).with(event: :run, transition_to: [:running] , from: [:standing])
      end
    end
    context 'when block is given' do
      let(:context) { double('event context', success?: true) }
      before do
        allow(Cycle).to receive(:call).with(base_object: subject) { context }
        allow_any_instance_of(Interstate::StateMachine).to receive(:state) { :on }
        interstate.initial_state(:off)
        interstate.on event: :cycle do |event|
          interstate.allow event: event, transition_to: [:on], from: [:off]
          interstate.allow event: event, transition_to: [:off], from: [:on]
        end
      end

      it 'define a method from event argument' do
        expect(subject).to respond_to(:cycle)
      end

      context 'and an event interactor is defined' do
        before { expect(Cycle).to receive(:call).with(base_object: subject )}

        it 'define a method from merging event and from arguments' do
          subject.cycle
          expect(subject).to respond_to(:cycle_off)
        end

        context 'when evaluating the transition' do
          context 'when event is successfull' do
            it 'sends next to state machine' do
              expect_any_instance_of(Interstate::StateMachine).to receive(:next)
              subject.cycle
            end
          end

          context 'and event is no successfull' do
            let(:context) { double('event context', success?: false, error: 'error') }

            it 'does not sends next to state machine' do
              expect_any_instance_of(Interstate::StateMachine).to_not receive(:next)
              subject.cycle
            end
          end
        end
      end
    end
  end

  describe '.initial_state(state)' do
    it 'sets initialized_state variable' do
      interstate.initial_state(:start)
      expect(interstate.initialized_state).to eq (:start)
    end
  end

  describe '.transition_table(*states)' do
    it 'sets machine_states variable' do
      interstate.transition_table(:off, :on) {}
      expect(interstate.machine_states).to eq [:off, :on]
    end
  end
end
