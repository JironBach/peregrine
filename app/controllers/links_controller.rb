class LinksController < ApplicationController
  include Amazon

  def new
    @link = Link.new
  end

  def create
    asin = link_params[:amzn_url].match("/([a-zA-Z0-9]{10})(?:[/?]|$)").to_s.gsub('/', "")
    aff_tag = link_params[:aff_tag]

    amazon_params = get_params(get_xml(asin, aff_tag))

    @link = Link.create(amazon_params)
    @link[:asin] = asin
    @link.aff_tag = aff_tag
    @link.amzn_aff_url = "http://www.amazon.com/gp/product/#{asin}/?tag=#{aff_tag}"
    @link.save
    redirect_to @link
  end

  def show
    @link = Link.find(params[:id])
    @new_link = Link.new
  end

  private
  def link_params
    params.require(:link).permit(:aff_tag, :amzn_url)
  end
end
