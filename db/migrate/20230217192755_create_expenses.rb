class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.monetize :value, null: false
      t.datetime :due_at, null: false, default: nil
      t.datetime :paid_at, null: true, default: nil

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade
      t.references :account, null: false, index: true, on_delete: :cascade
      t.references :category, null: false, index: true, on_delete: :cascade

      t.index ["slug", "user_id"], name: "user_id_expenses_slug_index", unique: true
      t.index ["name", "user_id"], name: "user_id_expenses_name_index", unique: true
    end
  end
end
