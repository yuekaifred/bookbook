require "open-uri"
require "aws-sdk-s3"

class BookImporter
  BUCKET = "book-covers"

  def self.from_work_id(id)
    existing = Book.find_by(ol_work_id: id)
    return existing if existing

    work      = fetch_json("https://openlibrary.org/works/#{id}.json")
    title     = work["title"] or raise "no title found for #{id}"
    author    = fetch_author(work)
    cover_key = fetch_and_upload_cover(id, work)

    Book.create!(title:, author:, ol_work_id: id, cover_key:)
  end

  private_class_method def self.fetch_json(url)
    raw = URI.open(url, "User-Agent" => "bookbook/1.0").read
    JSON.parse(raw)
  rescue OpenURI::HTTPError => e
    raise "Open Library request failed (#{url}): #{e.message}"
  end

  private_class_method def self.fetch_author(work)
    entries = work["authors"]
    return "Unknown" if entries.blank?

    key = entries.dig(0, "author", "key")
    return "Unknown" unless key

    author_id = key.split("/").last
    data = fetch_json("https://openlibrary.org/authors/#{author_id}.json")
    data["name"].presence || "Unknown"
  rescue => e
    Rails.logger.warn("BookImporter: could not fetch author — #{e.message}")
    "Unknown"
  end

  private_class_method def self.fetch_and_upload_cover(work_id, work)
    cover_ids = work["covers"]
    return nil if cover_ids.blank?

    url  = "https://covers.openlibrary.org/b/id/#{cover_ids[0]}-M.jpg"
    data = URI.open(url).read
    key  = "#{work_id}.jpg"

    s3_client.put_object(bucket: BUCKET, key: key, body: data, content_type: "image/jpeg")
    key
  rescue OpenURI::HTTPError
    Rails.logger.warn("BookImporter: could not fetch cover image for #{work_id}")
    nil
  end

  private_class_method def self.s3_client
    @s3_client ||= begin
      client = Aws::S3::Client.new(
        endpoint:          ENV.fetch("MINIO_ENDPOINT", "http://localhost:9000"),
        access_key_id:     ENV.fetch("MINIO_ACCESS_KEY", "minioadmin"),
        secret_access_key: ENV.fetch("MINIO_SECRET_KEY", "minioadmin"),
        region:            "us-east-1",
        force_path_style:  true
      )
      ensure_bucket(client)
      client
    end
  end

  private_class_method def self.ensure_bucket(client)
    client.create_bucket(bucket: BUCKET)
    client.put_bucket_policy(
      bucket: BUCKET,
      policy: {
        Version: "2012-10-17",
        Statement: [ {
          Effect:    "Allow",
          Principal: "*",
          Action:    "s3:GetObject",
          Resource:  "arn:aws:s3:::#{BUCKET}/*"
        } ]
      }.to_json
    )
  rescue Aws::S3::Errors::BucketAlreadyOwnedByYou, Aws::S3::Errors::BucketAlreadyExists
  end
end
