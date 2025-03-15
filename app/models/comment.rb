class Comment < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  
  validates :content, presence: true
  
  default_scope { order(created_at: :desc) }
end
