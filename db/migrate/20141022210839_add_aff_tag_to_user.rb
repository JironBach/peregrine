class AddAffTagToUser < ActiveRecord::Migration
  def change
    add_column :users, :aff_tag, :string
  end
end
