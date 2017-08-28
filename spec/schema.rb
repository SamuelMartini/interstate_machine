ActiveRecord::Schema.define do
  self.verbose = false

  create_table :traffic_lights, force: true do |t|
    t.string :name
    t.string :state

    t.timestamps
  end

  create_table :vehicles, force: true do |t|
    t.string :name
    t.string :state

    t.timestamps
  end

  create_table :orders, force: true do |t|
    t.string :address
    t.string :shipment
    t.string :state
    t.string :payment_state
    t.timestamps
  end
end
