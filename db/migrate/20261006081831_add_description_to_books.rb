class AddDescriptionToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :description, :text
  end
end
