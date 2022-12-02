class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, nil: false
      t.string :slug, nil: false

      t.timestamps
    end

    add_reference :categories, :user, index: true
  end
end
