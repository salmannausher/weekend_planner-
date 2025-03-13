class Comment < ApplicationRecord
  belongs_to :weekend
  
  validates :commenter_name, :commenter_email, :content, presence: true
  
  default_scope { order(created_at: :desc) }
end
