class MakeCoverKeyNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :books, :cover_key, true
  end
end
