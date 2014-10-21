class UpdateLinksColumns < ActiveRecord::Migration
    remove_column :links, :aff_url
    add_column :links, :sales_rank, :integer
end
