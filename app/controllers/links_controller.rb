class LinksController < ApplicationController

  def new
  end

  def create
    binding.pry
    params[:url].match("/([a-zA-Z0-9]{10})(?:[/?]|$)")

  end

end
