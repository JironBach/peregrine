class AddAffTagToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :aff_tag, :string
  end
end
