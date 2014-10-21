class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :asin
      t.string :name
      t.string :amzn_url
      t.string :sm_img_url
      t.string :med_img_url
      t.string :lg_img_url
      t.string :reviews_url
      t.string :aff_url
      t.string :amzn_aff_url
      t.string :short_aff_url
      t.string :aff_url_clicks
      t.timestamp
    end
  end
end
