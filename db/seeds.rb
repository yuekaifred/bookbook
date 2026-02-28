require "csv"

csv_path = Rails.root.join("db", "books.csv")

puts "Seeding books from #{csv_path}..."

CSV.foreach(csv_path, headers: true) do |row|
  work_id = row["ol_work_id"]
  puts "Processing work ID: #{work_id}"
  next if work_id.blank?

  BookImporter.from_work_id(work_id)
  sleep 0.4
end

puts "Done! #{Book.count} books in the database."
