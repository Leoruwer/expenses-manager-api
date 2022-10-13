class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, nil: false
      t.string :email, nil: false
      t.string :password, nil: false
      t.integer :user_type, default: 0

      t.timestamps
    end
  end
end
