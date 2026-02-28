class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :ol_work_id, null: false
      t.string :cover_key, null: false
      t.integer :elo_score, null: false, default: 1000

      t.timestamps
    end

    add_index :books, :ol_work_id, unique: true
  end
end
