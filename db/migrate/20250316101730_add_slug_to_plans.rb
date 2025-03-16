class AddSlugToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :slug, :string
    add_index :plans, :slug, unique: true
  end
end
