class CreateUsers < ActiveRecord::Migration[8.1]
  # Creates users with email, name, and phone fields and creation/update
  # timestamps; drops the table when the migration is rolled back.
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
