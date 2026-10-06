class CreateAuthorships < ActiveRecord::Migration[8.1]
  # Join table for the many-to-many relationship between authors and books.
  # The unique index stops the same author being linked to a book twice.
  def change
    create_table :authorships do |t|
      t.references :author, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
    add_index :authorships, [ :author_id, :book_id ], unique: true
  end
end
