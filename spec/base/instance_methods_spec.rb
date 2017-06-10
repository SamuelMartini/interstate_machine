require 'spec_helper'

RSpec.describe 'InstanceMethods' do
  let(:subject) { PlainRuby::TrafficLight.new }

  context '#states' do
    it 'returns an array of states' do
      expect(subject.states).to eq %i(stop proceed caution)
    end
  end
end
