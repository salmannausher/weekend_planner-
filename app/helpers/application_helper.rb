module ApplicationHelper
  # Safely generate a shared plan URL
  def safe_shared_plan_url(plan)
    shared_plan_url(token: plan.share_token) if plan.share_token.present?
  end
end
