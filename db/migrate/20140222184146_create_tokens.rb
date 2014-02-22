class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.text :token, null: false
      t.integer :user_id

      t.timestamps
    end

    add_index :tokens, :token, unique: true
    add_index :tokens, :user_id
  end
end
