class Vote < ApplicationRecord
  belongs_to :activity
  
  validates :voter_name, :voter_email, presence: true
  validates :vote_type, inclusion: { in: ['positive', 'negative', 'neutral'] }
  
  # Ensure one vote per activity per email
  validates :voter_email, uniqueness: { scope: :activity_id, message: "has already voted for this activity" }
end
