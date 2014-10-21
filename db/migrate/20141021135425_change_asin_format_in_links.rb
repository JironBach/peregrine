class ChangeAsinFormatInLinks < ActiveRecord::Migration
def up
    change_column :links, :asin, :string
  end

  def down
    change_column :links, :asin, :integer
  end
end
