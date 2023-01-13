class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, nil: false
      t.string :slug, nil: false, index: true

      t.timestamps

      t.references :user, nil: false, index: true, on_delete: :cascade
    end
  end
end
