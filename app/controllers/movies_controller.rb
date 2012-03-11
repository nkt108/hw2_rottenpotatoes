class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    redirect = false
    
    if params["sort"]
      @sort = session[:sort] = params["sort"]
    elsif session[:sort]
      redirect = true
    end
    
    @all_ratings = Movie.all_ratings
    
    if params["ratings"]
      session[:filter] = params["ratings"].keys
      redirect = true
    elsif params["filter"]
      @filter = session[:filter] = params["filter"]
    elsif session[:filter]
      redirect = true;
    else
      @filter = @all_ratings
    end
    
    if redirect
      redirect_to movies_path :sort => session[:sort], :filter => session[:filter]
    end
    
    @movies = Movie.where(:rating => @filter).order(@sort)
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
