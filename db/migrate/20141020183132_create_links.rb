class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :aff_url
      t.string :amzn_aff_url
      t.string :short_aff_url
      t.string :aff_url_clicks
      t.belongs_to :product, index: true
      t.timestamp
    end
  end
end
