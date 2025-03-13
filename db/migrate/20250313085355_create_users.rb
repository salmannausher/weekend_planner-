class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :google_token
      t.string :google_refresh_token

      t.timestamps
    end
  end
end
