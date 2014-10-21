class LinksController < ApplicationController

  def new
    @link = Link.new
  end

  def create
    require 'Amazon'
    binding.pry
    asin = @link.amzn_url.match("/([a-zA-Z0-9]{10})(?:[/?]|$)")
    aff_tag = @link.aff_tag
    a = Amazon.new
    a.get(asin, aff_tag)
    binding.pry

    @link = Link.create
    @link[:amzn_url] = params[:url]

    @link[]
  end
end
