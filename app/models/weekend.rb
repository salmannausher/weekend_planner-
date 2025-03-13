class Weekend < ApplicationRecord
  belongs_to :user
  has_many :activities, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :weather_forecasts, dependent: :destroy
  
  validates :title, :start_date, :end_date, :location, presence: true
  validates :share_token, uniqueness: true, allow_nil: true
  
  before_create :generate_share_token
  
  enum :status, { draft: 'draft', shared: 'shared', finalized: 'finalized' }
  
  private
  
  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(10)
  end
end
