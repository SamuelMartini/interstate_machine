require "spec_helper"

RSpec.describe PlainRuby::Vehicle do
  let(:vehicle) { described_class.new }
  before do
    expect(vehicle.state).to eq :parked
  end

  it "can properly run throught all the states" do
    vehicle.ignite
    expect(vehicle.state).to eq :idling

    vehicle.shift_up
    expect(vehicle.state).to eq :first_gear

    vehicle.shift_up
    expect(vehicle.state).to eq :second_gear

    vehicle.shift_up
    expect(vehicle.state).to eq :third_gear

    vehicle.shift_down
    expect(vehicle.state).to eq :second_gear

    vehicle.shift_down
    expect(vehicle.state).to eq :first_gear

    vehicle.crash
    expect(vehicle.state).to eq :stalled

    vehicle.repair
    expect(vehicle.state).to eq :parked

    vehicle.ignite
    expect(vehicle.state).to eq :idling

    vehicle.shift_up
    expect(vehicle.state).to eq :first_gear

    vehicle.idle
    expect(vehicle.state).to eq :idling
  end

  it 'returns error when transition rule is not respected' do
    expect { vehicle.crash }.to raise_error RuntimeError
    expect(vehicle.state).to eq :parked
  end

  context 'when event has multiple transition and is called in wrong state' do
    it 'returns error' do
      expect { vehicle.shift_down }.to raise_error RuntimeError
    end
  end
end
