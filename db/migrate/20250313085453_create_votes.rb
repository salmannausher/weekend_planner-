class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.references :activity, null: false, foreign_key: true
      t.string :voter_name
      t.string :voter_email
      t.string :vote_type

      t.timestamps
    end
  end
end
