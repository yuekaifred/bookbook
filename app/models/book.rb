class Book < ApplicationRecord
  validates :title, :author, :ol_work_id, presence: true
  validates :ol_work_id, uniqueness: true

  has_many :won_matches, class_name: "Match", foreign_key: "winner_id"
  has_many :lost_matches, class_name: "Match", foreign_key: "loser_id"

  def display_title
    self[:display_title].presence || title
  end

  def display_author
    self[:display_author].presence || author
  end
end
