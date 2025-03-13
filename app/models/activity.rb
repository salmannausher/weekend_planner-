class Activity < ApplicationRecord
  belongs_to :weekend
  has_many :votes, dependent: :destroy
  
  validates :name, :description, presence: true
  
  def vote_count
    votes.count
  end
  
  def positive_votes
    votes.where(vote_type: 'positive').count
  end
  
  def negative_votes
    votes.where(vote_type: 'negative').count
  end
end
