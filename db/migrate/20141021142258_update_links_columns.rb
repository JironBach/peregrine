class UpdateLinksColumns < ActiveRecord::Migration[4.2]
    remove_column :links, :aff_url
    add_column :links, :sales_rank, :integer
end
