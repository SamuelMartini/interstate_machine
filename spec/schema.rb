ActiveRecord::Schema.define do
  self.verbose = false

  create_table :traffic_lights, force: true do |t|
    t.string :name
    t.string :state

    t.timestamps
  end
end
