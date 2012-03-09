class Movie < ActiveRecord::Base
  def Movie.all_ratings()
    ordering = ['X','NC-17','R','PG-13','PG','G']
    return self.
      select(:rating).
      map {|m| m.rating}.
      uniq.
      sort {|x,y| ordering.index(y) <=> ordering.index(x)}
  end
end
