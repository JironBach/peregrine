class Link < ActiveRecord::Base
  # validate :has_valid_amazon_product_url

  # def has_valid_amazon_product_url
  #   if :amzn_url.match(/amazon.com/i)
  #     errors.add(:amzn_url, "is not an amazon url")
  #   elsif :amzn_url.match("/([a-zA-Z0-9]{10})(?:[/?]|$)")
  #     errors.add(:amzn_url, "is not a valid product url")
  #   end
  # end
end
