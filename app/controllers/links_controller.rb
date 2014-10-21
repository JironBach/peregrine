class LinksController < ApplicationController
  # include Amazon

  def new
    @link = Link.new
  end

  def create

    asin = link_params[:amzn_url].match("/([a-zA-Z0-9]{10})(?:[/?]|$)")
    aff_tag = link_params[:aff_tag]

    get_xml(asin, aff_tag)
    binding.pry

    @link = Link.create
    @link[:amzn_url] = params[:url]

  end

  private
  def link_params
    params.require(:link).permit(:amzn_url, :aff_tag)
  end
end
