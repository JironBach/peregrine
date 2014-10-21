class LinksController < ApplicationController

  def new
  end

  def create
    binding.pry
    @link = Link.new
    asin = params[:url].match("/([a-zA-Z0-9]{10})(?:[/?]|$)")
    @product = Product.find_or_create_by(asin: asin)

  end

end
