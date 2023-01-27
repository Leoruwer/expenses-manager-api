class CreateDefaultBills < ActiveRecord::Migration[7.0]
  def change
    create_table :default_bills do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.monetize :value, null: true

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade

      t.index ["slug", "user_id"], name: "user_id_default_bills_slug_index", unique: true
      t.index ["name", "user_id"], name: "user_id_default_bills_name_index", unique: true
    end
  end
end
