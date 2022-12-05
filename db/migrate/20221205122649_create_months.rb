class CreateMonths < ActiveRecord::Migration[7.0]
  def change
    create_table :months do |t|
      t.string :name, nil: false
      t.string :slug, nil: false

      t.timestamps
    end

    add_reference :months, :user, index: true
  end
end
