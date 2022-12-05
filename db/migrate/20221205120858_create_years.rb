class CreateYears < ActiveRecord::Migration[7.0]
  def change
    create_table :years do |t|
      t.string :name, nil: false
      t.string :slug, nil: false

      t.timestamps
    end

    add_reference :years, :user, index: true
  end
end
