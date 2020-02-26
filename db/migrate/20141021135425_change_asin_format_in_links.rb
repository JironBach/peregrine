class ChangeAsinFormatInLinks < ActiveRecord::Migration[4.2]
def up
    change_column :links, :asin, :string
  end

  def down
    change_column :links, :asin, :integer
  end
end
