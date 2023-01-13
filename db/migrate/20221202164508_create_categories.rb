class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, nil: false
      t.string :slug, nil: false, index: { unique: true }

      t.timestamps

      t.references :user, null: false, index: true, on_delete: :cascade
    end
  end
end
