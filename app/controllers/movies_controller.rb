class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    options = {}
    
    if params["sort"] == "title"
      @sort = "title"
      options[:order] = @sort
    elsif params["sort"] == "release_date"
      @sort = "release_date"
      options[:order] = @sort
    end
    
    if params["filter"]
      @filter = params["filter"]
    else
      @filter = []
    end
    
    params["ratings"].each_key {|key| @filter.push key} if params["ratings"]
    
    if @filter.length > 0
      options[:conditions] = ["rating IN (?)", @filter]
    end
    
    @movies = Movie.find :all, options
    @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
