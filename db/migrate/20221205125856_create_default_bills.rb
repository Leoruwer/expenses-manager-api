class CreateDefaultBills < ActiveRecord::Migration[7.0]
  def change
    create_table :default_bills do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.monetize :value, null: true

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade
    end
  end
end
