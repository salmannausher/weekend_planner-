class CreateWeekends < ActiveRecord::Migration[8.0]
  def change
    create_table :weekends do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.string :location
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :share_token
      t.string :status

      t.timestamps
    end
    add_index :weekends, :share_token, unique: true
  end
end
