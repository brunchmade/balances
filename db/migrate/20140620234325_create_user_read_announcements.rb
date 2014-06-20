class CreateUserReadAnnouncements < ActiveRecord::Migration
  def change
    create_table :user_read_announcements do |t|
      t.integer :user_id
      t.integer :announcement_id

      t.timestamps
    end

    add_index :user_read_announcements, :user_id
    add_index :user_read_announcements, :announcement_id
  end
end
