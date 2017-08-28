# Interstate
When state machine meets interactor. Interstate is a simple state machine which use interactors to trigger transitions. Long story short, an object receives an event which is a interactor and you can do fantastic thinks with interactors.
What is an interactor?
*"An interactor is a simple, single-purpose object."*
[here](https://github.com/collectiveidea/interactor)

## Installation

## Usage
### a simple example:
```ruby
class TrafficLight < ActiveRecord::Base
  include Interstate

  initial_state :stop

  transition_table :stop, :proceed, :caution do
    on event: :cycle do |event|
      allow event: event, transition_to: [:proceed], from: [:stop]
      allow event: event, transition_to: [:caution], from: [:proceed]
      allow event: event, transition_to: [:stop], from: [:caution]
    end
    on event: :tilt, transition_to: [:broken], from: [:proceed, :caution, :stop]
    on event: :repair, transition_to: [:stop], from: [:broken]
  end
end
```
`transition_table` is where the state machine rules are defined.
Each event represent an `Interactor` that is called to process the transition.

`on` can take a block which defines different transition(rules) for the same event or a single transition

In addition to the class where you define the state machine, you also need to create interactors for each event.

In this case we have an event `cycle` that trigger many transitions so we define five interactors
`CycleProceed`, `CycleCaution`, `CycleStop` and then `Tilt` and `Repair`. Yes, when an event triggers a transition to a single state you have to  name the class like the event itself.

```ruby
class CycleProceed
  include Interactor

  before :validate_transition

  def call
    # do stuff needed when this state happen
    'yeah'
  end

  private

  def validate_transition
    context.fail!(error: 'there is no power') if context.object.power == 0
  end
end
```
Note: You can use all the [interactor](https://github.com/collectiveidea/interactor) magics. Whoop!

You can access the class where you have included Interstate by `context.object`

When transition is allowed:
```ruby
t = TrafficLight.new
t.cycle
#=> :proceed
```

When transition can't happen because something wrong executing the event

```ruby
t.power = 0
t.cycle
v.ignite
#=> 'there is no power'
t.state
#=> :stop
```

When transition is no allowed
```ruby
t.state
#=> :stop
t.repair
#=> RuntimeError Exception:
```
## Contributing
Feel free to play around, fork, add, pull request, and get a hug. If you decide to pull request please add tests
