class LeaderboardController < ApplicationController
  def index
    @books = Book.order(elo_score: :desc)
  end
end
