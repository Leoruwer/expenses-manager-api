class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade
    end
  end
end
