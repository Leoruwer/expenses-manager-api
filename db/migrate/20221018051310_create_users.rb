class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.string :slug, null: false, index: true
      t.string :password_digest, null: false
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
