class CompareController < ApplicationController
  def index
    @book_a, @book_b = Book.order("RANDOM()").limit(2)
  end

  def vote
    winner = Book.find(params[:winner_id])
    loser  = Book.find(params[:loser_id])

    flash[:vote_delta] = EloCalculator.preview_delta(winner, loser)

    EloCalculator.update(winner, loser)
    Match.create!(winner: winner, loser: loser)

    redirect_to root_path
  end
end
