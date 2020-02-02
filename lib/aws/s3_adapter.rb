class Aws::S3Adapter
  def initialize()
    @client = Aws::S3::Resource.new
  end

  def get_buckets
    @client.list_buckets.buckets.map(&:name)
  end

  def upload(bucket, filename, path)
    @client.bucket(bucket).object(filename).upload_file(path)
  end

  def delete(bucket, filename)
    @client.bucket(bucket).object(filename).delete
  end
end
