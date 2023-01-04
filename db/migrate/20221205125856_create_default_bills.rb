class CreateDefaultBills < ActiveRecord::Migration[7.0]
  def change
    create_table :default_bills do |t|
      t.string :name, nil: false
      t.string :slug, nil: false
      t.monetize :value, nil: true

      t.timestamps
    end

    add_reference :default_bills, :user, index: true
  end
end
