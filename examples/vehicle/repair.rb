class Repair
  include Interactor

  def call
    puts "changing the state after #{self.class} event"
  end
end
