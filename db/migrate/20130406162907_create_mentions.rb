class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :micropost_id
      t.integer :user_id

      t.timestamps
    end
    add_index :mentions, :user_id
    add_index :mentions, [:micropost_id, :user_id], 
    			unique: true
  end
end
