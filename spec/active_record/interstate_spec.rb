require 'spec_helper'

RSpec.describe 'Interstate' do
  let(:record) { TrafficLight.new(name: 'Traffic', state: 'caution') }

  describe '#state' do
    context 'when state is present on record field' do
      let(:record) { TrafficLight.new(name: 'Traffic', state: 'proceed') }

      it 'returns the current state' do
        expect(record.state).to eq 'proceed'
      end
    end

    context 'when state is nil on record field' do
      let(:record) { TrafficLight.new(name: 'Traffic', state: nil) }

      it 'returns the initial state' do
        expect(record.state).to eq 'stop'
      end
    end
  end

  describe '#states' do
    it 'returns all states' do
      expect(record.states).to eq [:stop, :proceed, :caution]
    end
  end
end
