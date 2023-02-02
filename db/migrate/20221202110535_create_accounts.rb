class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade

      t.index ["slug", "user_id"], name: "user_id_accounts_slug_index", unique: true
      t.index ["name", "user_id"], name: "user_id_accounts_name_index", unique: true
    end
  end
end
