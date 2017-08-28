require 'spec_helper'

RSpec.describe 'InstanceMethods' do
  let(:subject) { PlainRuby::TrafficLight.new }

  it 'instantiates a state machine' do
    allow(InterstateMachine::StateMachine).to receive(:new)
    expect(InterstateMachine::StateMachine).to have_received(:new).with(subject)
  end
end
