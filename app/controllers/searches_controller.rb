class SearchesController < ApplicationController

  def create
    @search = Search.new(search_params)
    @search.set_query_url
    @search.save
    puts "saved"
    session[:search][:search] = @search.search
    session[:search][:location] = @search.location
    puts "saved to session"
    redirect_to search_result_path(@search.query)
  end

  def update
    @search = Search.find(params[:id])
    @search.update(search_params)
    @search.set_query_url
    @search.save
    redirect_to search_result_path(@search.query)
  end

  def show
    find_user
    puts "find user"
    @search = Search.find_by(query: params[:query])
    puts "finding search"
    # 400 request handling
    resp = RestClient.get(@search.api_url){ | response, request, result, &block |
      case response.code
      when 200
        response.return!
      else
        flash[:message] = "No search results: make sure your location includes a state or zip code."
        redirect_to root_path and return
      end
    }
    puts "parsing response"
    resp = JSON.parse(resp)
    puts "response: #{resp}"
    @restaurants = resp["response"]["venues"]
    @restaurants = @search.map_restaurants(@restaurants)
  end

  private

  def search_params
    params.require(:search).permit(:query, :search, :location)
  end

end
