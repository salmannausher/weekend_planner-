class Plan < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  belongs_to :user
  has_many :activities, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :weather_forecasts, dependent: :destroy
  
  validates :title, :start_date, :end_date, :location, presence: true
  validates :share_token, uniqueness: true, allow_nil: true
  
  before_create :generate_share_token
  
  enum :status, { draft: 'draft', shared: 'shared', finalized: 'finalized' }
  
  # Define slug candidates for FriendlyId
  # This will try each candidate in order until it finds a unique one
  def slug_candidates
    [
      :title,
      [:title, :status],
      [:title, :status, :id]
    ]
  end
  
  # Regenerate slug when title or status changes
  def should_generate_new_friendly_id?
    title_changed? || status_changed? || super
  end
  
  private
  
  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(10)
  end
end
