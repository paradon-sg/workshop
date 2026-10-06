class AddDescriptionToAuthors < ActiveRecord::Migration[8.1]
  def change
    add_column :authors, :description, :text
  end
end
