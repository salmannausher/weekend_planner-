class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :weekend, null: false, foreign_key: true
      t.string :commenter_name
      t.string :commenter_email
      t.text :content

      t.timestamps
    end
  end
end
