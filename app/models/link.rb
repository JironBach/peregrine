class Link < ActiveRecord::Base
   belongs_to :user

   def percent_sales_rank
    if self.sales_rank == 0
      0
    else
      100./(1+0.00002*self.sales_rank*self.sales_rank)
    end
  end
end
