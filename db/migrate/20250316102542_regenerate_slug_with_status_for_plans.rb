class RegenerateSlugWithStatusForPlans < ActiveRecord::Migration[8.0]
  def up
    # Load the Plan model
    Plan.reset_column_information
    
    # Find plans with duplicate titles
    duplicate_titles = Plan.group(:title).having("COUNT(*) > 1").pluck(:title)
    
    # For each duplicate title, regenerate slugs using title and status
    duplicate_titles.each do |title|
      plans = Plan.where(title: title)
      plans.each do |plan|
        # Skip plans without a status
        next if plan.status.blank?
        
        # Generate a new slug using title and status
        new_slug = "#{plan.title.parameterize}-#{plan.status}"
        
        # Ensure the slug is unique
        counter = 1
        while Plan.where(slug: new_slug).where.not(id: plan.id).exists?
          new_slug = "#{plan.title.parameterize}-#{plan.status}-#{counter}"
          counter += 1
        end
        
        # Update the slug
        plan.update_column(:slug, new_slug)
      end
    end
    
    # For plans with nil status, set a default status
    Plan.where(status: nil).each do |plan|
      plan.update_column(:status, 'draft')
      
      # Regenerate the slug
      new_slug = "#{plan.title.parameterize}-draft"
      
      # Ensure the slug is unique
      counter = 1
      while Plan.where(slug: new_slug).where.not(id: plan.id).exists?
        new_slug = "#{plan.title.parameterize}-draft-#{counter}"
        counter += 1
      end
      
      # Update the slug
      plan.update_column(:slug, new_slug)
    end
  end

  def down
    # This migration is not reversible
  end
end
