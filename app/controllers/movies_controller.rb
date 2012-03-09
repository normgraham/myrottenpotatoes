class MoviesController < ApplicationController
  @title_hilite = ''
  @release_date_hilite = ''
  @all_ratings = []

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    sort_by = params[:sort_by]
    if sort_by =~ /title/
      @title_hilite = 'hilite'
      @release_date_hilite = ''
      @movies = Movie.all(:order => 'title')
    elsif sort_by =~ /release_date/
      @title_hilite = ''
      @release_date_hilite = 'hilite'
      @movies = Movie.all(:order => 'release_date')
    else
      @title_hilite = ''
      @release_date_hilite = ''
      @movies = Movie.all
    end
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
