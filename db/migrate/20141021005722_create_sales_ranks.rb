class CreateSalesRanks < ActiveRecord::Migration
  def change
    create_table :sales_ranks do |t|
      t.integer :rank
      t.belongs_to :link, index: true
      t.timestamp
    end
  end
end
