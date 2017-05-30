# Interstate

## Installation

## Usage
You can check the following example here https://github.com/SamuelMartini/interstate/tree/spike/examples/vehicle

Create a class Vehicle and include Interstate

`transition_table` is where the state machine rules are defined.
Each event represent an `Interactor` which is called to process the transition.

```ruby
class Vehicle
  include Interstate

  initial_state :parked

  transition_table :parked, :idling, :first_gear, :second_gear, :third_gear, :stalled do
    on event: :park, transition_to: [:parked], from: [:idling, :first_gear]
    on event: :ignite, transition_to: [:idling], from: [:parked]
    on event: :idle, transition_to: [:idling], from: [:first_gear]
    on event: :shift_up do |event|
      allow event: event, transition_to: [:first_gear], from: [:idling]
      allow event: event, transition_to: [:second_gear], from: [:first_gear]
      allow event: event, transition_to: [:third_gear], from: [:second_gear]
    end
    on event: :shift_down do |event|
      allow event: event, transition_to: [:second_gear], from: [:third_gear]
      allow event: event, transition_to: [:first_gear], from: [:second_gear]
    end
    on event: :crash, transition_to: [:stalled], from: [:first_gear, :second_gear, :third_gear]
    on event: :repair, transition_to: [:parked], from: [:stalled]
  end
end
```

Note: `on` can take a block which defines different transition(rules) for the same event

```ruby
RSpec.describe Vehicle do
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
end
```
## Development

## Contributing

## License
