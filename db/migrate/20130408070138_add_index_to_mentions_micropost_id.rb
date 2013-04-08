class AddIndexToMentionsMicropostId < ActiveRecord::Migration
  def change
  	add_index :mentions, :micropost_id
  end
end
