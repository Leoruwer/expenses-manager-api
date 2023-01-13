class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade
    end
  end
end
