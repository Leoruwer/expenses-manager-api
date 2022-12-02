class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, nil: false
      t.string :slug, nil: false

      t.timestamps
    end

    add_reference :accounts, :user, index: true
  end
end
