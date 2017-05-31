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

When transition is allowed
```ruby
v.ignite
#=> :idling
```
When transition can't happen because something wrong executing the event
```ruby
class Ignite
  include Interactor

  def call
    context.fail!(error: 'no gas')
  end
end

v.ignite
#=> "no gas"
v.state
#=> :parked
```

When transition is no allowed
```ruby
v.state
#=> :parked
v.shift_up
#=> RuntimeError Exception:
```
## Development

## Contributing

## License
