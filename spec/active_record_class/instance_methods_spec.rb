require 'spec_helper'

RSpec.describe 'InstanceMethods' do
  let(:subject) { ActiveRecord::TrafficLight.new }

  it 'instantiates a state machine' do
    allow(Interstate::StateMachine).to receive(:new)
    expect(Interstate::StateMachine).to have_received(:new).with(subject)
  end
end
