class EloCalculator
  K = 32

  def self.update(winner, loser)
    expected_winner = 1.0 / (1 + 10 ** ((loser.elo_score - winner.elo_score) / 400.0))
    expected_loser  = 1.0 - expected_winner

    winner.update!(elo_score: (winner.elo_score + K * (1 - expected_winner)).round)
    loser.update!(elo_score:  (loser.elo_score  + K * (0 - expected_loser)).round)
  end

  def self.preview_delta(winner, loser)
    expected = 1.0 / (1 + 10 ** ((loser.elo_score - winner.elo_score) / 400.0))
    (K * (1 - expected)).round
  end
end
