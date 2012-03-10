class MoviesController < ApplicationController
  def initialize
    @all_ratings = Movie.all_ratings
    @selected_ratings = Movie.all_ratings
    super
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = params[:ratings].keys if params[:ratings] != nil
    @sort_by = params[:sort_by] if params[:sort_by] != nil
    @select_hash = {}
    @selected_ratings.each {|r| @select_hash.store("ratings[#{r}]",1)}

    if @sort_by =~ /title/
      @title_hilite = 'hilite'
      @release_date_hilite = ''
      @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings}, :order => 'title')
    elsif @sort_by =~ /release_date/
      @title_hilite = ''
      @release_date_hilite = 'hilite'
      @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings}, :order => 'release_date')
    else
      @title_hilite = ''
      @release_date_hilite = ''
      @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings})
    end
    flash[:sort_by => @sort_by]
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
