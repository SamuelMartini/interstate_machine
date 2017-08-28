# InterstateMachine
When state machine meets interactor. InterstateMachine is a simple state machine which use interactors to trigger transitions. Long story short, an object receives an event which is a interactor and you can do fantastic things with interactors.
What is an interactor?
[*"An interactor is a simple, single-purpose object."*](https://github.com/collectiveidea/interactor)

## Installation
```ruby
gem install interstate_machine --pre
```

Gemfile
```ruby
gem 'interstate_machine', '~> 1.0.1.pre'
```

## Usage
```ruby
class TrafficLight < ActiveRecord::Base
  include InterstateMachine

  initial_state :stop

  transition_table :stop, :proceed, :caution, :tilt, :broken do
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
If you want to use `InterstateMachine` in plain ruby, add `attr_accessor :state` to store the state.
`transition_table` is where the state machine rules and states are defined.
Each event represent an `Interactor` that is called to process the transition.

`on` can take a block which defines different transition(rules) for the same event or a single transition

In addition to the class where you define the state machine, you also need to create interactors for each event.

In this case we have an event `cycle` that trigger many transitions so we define three interactors for the `cycle` event and two for the remaining.
`CycleProceed`, `CycleCaution`, `CycleStop` and then `Tilt` and `Repair`. Yes, when an event triggers a transition to a single state and it's not a block, you have to name the class like the event name.

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
Note: You can use all the magics like [hooks](https://github.com/collectiveidea/interactor). Whoop!

You can access the class where you have included InterstateMachine by `context.object`

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
