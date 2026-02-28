class Match < ApplicationRecord
  belongs_to :winner, class_name: "Book"
  belongs_to :loser, class_name: "Book"
end
