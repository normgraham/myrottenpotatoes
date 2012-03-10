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
    if !params.key? :rating and !params.key? :sort_by
      # no state was passed in the URI. Let's check session
      if (session.key? :select_hash and !session[:select_hash].empty?) or session.key? :sort_by
        # we've got some session state. let's use it.
        redirect_to movies_path(session[:select_hash].merge({:sort_by => session[:sort_by]}))
      end
    end

    @select_hash = {}
    if params.key? :ratings
      @selected_ratings = params[:ratings].keys
      @selected_ratings.each {|r| @select_hash.store("ratings[#{r}]",1)}
    end
    if params.key? :sort_by
      @sort_by = params[:sort_by]
    end

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
    session[:sort_by] = @sort_by
    session[:select_hash] = @select_hash
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
