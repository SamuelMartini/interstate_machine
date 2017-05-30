require 'spec_helper'

RSpec.describe Interstate do
  let(:interstate) { Class.new.send(:include, described_class) }

  describe '.new' do
    let(:subject) { interstate.new }

    it 'instantiates a state machine' do
      expect(subject.state_machine).to be_instance_of Interstate::StateMachine
    end
  end

  describe '#state' do
    it 'return the current state' do
      interstate.initial_state(:on)
      interstate.transition_table :off, :on {}
      instance = interstate.new
      expect(instance.state).to eq :on
    end
  end

  describe '#states' do
    it 'return all states' do
      interstate.initial_state(:on)
      interstate.transition_table :off, :on {}
      instance = interstate.new
      expect(instance.states).to eq [:off, :on]
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
      interstate.transition_table :off, :on {}
      expect(interstate.machine_states).to eq [:off, :on]
    end
  end
end
