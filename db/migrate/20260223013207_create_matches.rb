class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.integer :winner_id, null: false
      t.integer :loser_id, null: false

      t.timestamps
    end

    add_index :matches, :winner_id
    add_index :matches, :loser_id
    add_foreign_key :matches, :books, column: :winner_id
    add_foreign_key :matches, :books, column: :loser_id
  end
end
