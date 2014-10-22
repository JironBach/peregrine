class AddUserIdToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :user_id, :integer
    add_index 'links', ['user_id']\
  end

  def self.down
    remove_column :links, :user_id
  end
end
