class Product < ActiveRecord::Base
  has_many :sales_ranks
  belongs_to :link
end
