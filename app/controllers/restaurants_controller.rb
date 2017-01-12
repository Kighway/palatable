class RestaurantsController < ApplicationController

  def dummy_create
    session[:dummy_restaurant] = Restaurant.new(name: params[:name], address: params[:address].join("~"), foursquare_id: params[:foursquare_id])
    session[:reformatted_address] = session[:dummy_restaurant].address.split("~")
    session[:dummy_restaurant].set_attributes
    render :'/restaurants/dummy_show'
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end


  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :foursquare_id)
  end



end
