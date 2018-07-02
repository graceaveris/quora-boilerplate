
class CreateVotes < ActiveRecord::Migration[5.0]

  def change
      create_table :votes do |t|
      	t.belongs_to :answer, index: true
      	t.integer :vote_number
      	t.timestamps
  end
  end
end
