class FaceImagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  protect_from_forgery except: [:create]

  def new
  end

  def create
    bucket = ENV['S3_SEARCHBUCKET']
    collection_id = "face-images"
    delete_old_img(@current_user, collection_id, bucket) if @current_user.face_image.present?
    # s3に画像をアップロード
    filename = upload_img_to_s3(bucket, params)
    # collectionに画像を登録
    @result = add_img_to_collection(@current_user.id, collection_id, bucket, filename)
  end

  private

  def delete_old_img(user, c_id, bucket)
    face_image = user.face_image
    # collectionから削除
    rekog = Aws::RekognitionAdapter.new
    rekog.delete_face_from_collection(c_id, face_image.face_id)
    # s3から削除
    s3 = Aws::S3Adapter.new
    s3.delete(bucket, face_image.filename)
    # FaceImageを削除
    face_image.destroy!
  end

  def file_decoded_from(b64img)
    tempfile = Base64.decode64(b64img)
    file = Tempfile.new('img')
    file.binmode
    file << tempfile
    file.rewind
    file
  end

  def upload_img_to_s3(bucket, params)
    s3 = Aws::S3Adapter.new
    filename = SecureRandom.uuid + ".jpg"
    img_src = params[:img_src]
    content_type, b64img = img_src.match(/data:(.*?);(?:.*?),(.*)$/).captures
    img = file_decoded_from(b64img);
    # tmpに画像を一時保存
    File.open("tmp/storage/#{filename}", 'wb') do |f|
      f.write(img.read)
    end
    path = "tmp/storage/#{filename}"
    s3.upload(bucket, filename, path) # s3にアップロード
    FileUtils.rm(path) # tmpファイル削除
    filename
  end

  def search_image_from_collection(collection_id, filename)
    rekog = Aws::RekognitionAdapter.new
    rekog.search_faces_by_image(collection_id, ENV['S3_SEARCHBUCKET'], filename)
  rescue => e
    {}
  end

  def add_img_to_collection(user_id, c_id, bucket, filename)
    rekog = Aws::RekognitionAdapter.new
    search_result = search_image_from_collection(c_id, filename)
    # すでに登録されている顔かどうかチェック
    if search_result.face_matches.try(:present?)
      s3 = Aws::S3Adapter.new
      s3.delete(bucket, filename)
      {face_exist: true}
    else
      rekog.add_face_to_collection(user_id, c_id, bucket, filename)
    end
  end
end
