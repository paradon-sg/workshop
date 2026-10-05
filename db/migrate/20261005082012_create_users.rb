class CreateUsers < ActiveRecord::Migration[8.1]
  # Creates users with nullable email, name, and phone fields and timestamps.
  # Rolling back drops the table and its data.
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone

      t.timestamps
    end
  end
end
