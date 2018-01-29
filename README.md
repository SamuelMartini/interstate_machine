[![Maintainability](https://api.codeclimate.com/v1/badges/9ccdfa6f85632ebd9e41/maintainability)](https://codeclimate.com/github/SamuelMartini/interstate_machine/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/9ccdfa6f85632ebd9e41/test_coverage)](https://codeclimate.com/github/SamuelMartini/interstate_machine/test_coverage)
# InterstateMachine
When state machine meets interactor. InterstateMachine is a simple state machine which use interactors to trigger transitions. Long story short, an object receives an event which is a interactor and you can do fantastic things with interactors.
What is an interactor?
[*"An interactor is a simple, single-purpose object."*](https://github.com/collectiveidea/interactor)

## Installation
```ruby
gem install interstate_machine
```

Gemfile
```ruby
gem 'interstate_machine', '~> 1.0.0'
```

## Usage
```ruby
class Order
  include InterstateMachine

  attr_accessor :state

  initial_state :cart

  transition_table :cart, :payment, :complete do
    on event: :next do |event|
      allow event: event, transition_to: [:payment], from: [:cart]
    end
    on event: :complete, transition_to: [:complete], from: [:payment]
  end
end
```
When including `InterstateMachine` in an ActiveRecord class, it does not need any attr_accessor to store the state.
`transition_table` is where the state machine rules and states are defined.
Each event represent an `Interactor` that is called to process the transition.

`on` can take a block which defines different transition(rules) for the same event or a single transition

In addition to the class where you define the state machine, you also need to create interactors for each event.

In this case we have an event `next` that could trigger many transitions(:cart, :address, :payment and so on) so we define an interactors for each of them.
`NextPayment`, `Complete`. Yes, when an event triggers a transition to a single state and it's not a block, you have to name the class like the event name.

In a normal checkout you proably have something like `NextAddress`, `NextDelivery`, `NextPayment`, `NextConfirm`, `Complete`


```ruby
class NextPayment
  include Interactor

  before :ensure_line_item

  def call
    # update order totals ..
  end

  private

  def ensure_line_item
    context.fail!(error: 'you need to add a product!') unless context.object.line_items.present?
  end
end
```
Note: You can use all the interactor magic (before, around, after) [hooks](https://github.com/collectiveidea/interactor). Whoop!

You can access the class where you have included InterstateMachine with `context.object`

When transition is allowed:
```ruby
order = Order.new
order.add(line_item)
order.next
#=> :payment
```

When transition can't happen because something wrong executing the event

```ruby
order = Order.new
order.next
#=> 'you need to add a product!'
```

When transition is no allowed
```ruby
order = Order.new
order.state
#=> :cart
order.complete
#=> RuntimeError Exception:
```
## Contributing
Feel free to play around, fork, add, pull request, and get a hug. If you decide to pull request please add tests
