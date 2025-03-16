class GenerateSlugsForExistingPlans < ActiveRecord::Migration[8.0]
  def up
    # Load the Plan model
    Plan.reset_column_information
    
    # Generate slugs for all existing plans
    Plan.find_each do |plan|
      # Skip plans that already have a slug
      next if plan.slug.present?
      
      # Generate a slug based on the title
      plan.slug = plan.title.parameterize
      
      # Ensure the slug is unique
      counter = 1
      while Plan.where(slug: plan.slug).where.not(id: plan.id).exists?
        plan.slug = "#{plan.title.parameterize}-#{counter}"
        counter += 1
      end
      
      # Save the plan without validations or callbacks
      plan.save(validate: false)
    end
  end

  def down
    # This migration is not reversible
  end
end
