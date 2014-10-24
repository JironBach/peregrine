class LinksController < ApplicationController
  include Amazon

  def new
    @link = Link.new
  end

  def create

    return redirect_to :back, alert: "Please enter an affiliate tag." if link_params[:aff_tag] == ""

    if amazon_url?
      if product_url?

        @link = Link.create({
          asin: get_asin,
          aff_tag: link_params[:aff_tag],
          amzn_url: link_params[:amzn_url],
          amzn_aff_url: "http://www.amazon.com/gp/product/#{get_asin}/?tag=#{link_params[:aff_tag]}"
          })

        # Call to Amazon API
        @link.update(get_params(get_xml(get_asin, link_params[:aff_tag])))
        @link.save

        redirect_to @link

      else
        redirect_to :back, alert: "Please enter a Amazon product URL."
      end

    else
      redirect_to :back, alert: "Please enter a valid Amazon URL."
    end

    update_aff_tag_if_user_logged_in
  end


  def show
    @link = Link.find(params[:id])
    @new_link = Link.new
  end

  private

  def link_params
    params.require(:link).permit(:aff_tag, :amzn_url)
  end

  def amazon_url?
    link_params[:amzn_url].match("amazon.com") ? true : false
  end

  def product_url?
    link_params[:amzn_url].match("/([a-zA-Z0-9]{10})(?:[/?]|$)") ? true : false
  end

  def get_asin
    link_params[:amzn_url].match("/([a-zA-Z0-9]{10})(?:[/?]|$)").to_s.gsub('/', "")
  end

  def update_aff_tag_if_user_logged_in
    if user_signed_in?
      current_user.aff_tag = link_params[:aff_tag]
      current_user.save
    end
  end
end
