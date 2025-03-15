class Activity < ApplicationRecord
  belongs_to :plan
  has_many :votes, dependent: :destroy
  
  validates :name, presence: true
  
  # Scopes
  scope :by_votes, -> { left_joins(:votes).group(:id).order('COUNT(votes.id) DESC') }
  
  # Methods
  def voted_by?(user)
    return false unless user
    votes.exists?(user_id: user.id)
  end
  
  def vote_count
    votes.count
  end
  
  def toggle_vote(user)
    return unless user
    
    if voted_by?(user)
      votes.find_by(user_id: user.id).destroy
    else
      votes.create(user_id: user.id)
    end
  end
  
  def positive_votes
    votes.where(vote_type: 'positive').count
  end
  
  def negative_votes
    votes.where(vote_type: 'negative').count
  end
end
