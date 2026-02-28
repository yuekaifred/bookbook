class AddDisplayNamesToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :display_title, :string
    add_column :books, :display_author, :string
  end
end
