class FaceLoginController < ApplicationController
  skip_before_action :login_required, only: [:index, :check]
  before_action :redirect_login_user
  skip_before_action :verify_authenticity_token

  protect_from_forgery except: [:check]

  def index
  end

  def check
    filename = upload_img_to_s3(params)
    @result = search_image_from_collection("face-images", filename)
    unless @result.empty? || @result.face_matches.empty?
      user_id = @result.face_matches[0].face.external_image_id
      user = User.find(user_id)
      sign_in(user)
    end
    delete_img_from_s3(ENV['S3_PUTBUCKET'], filename)
    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def upload_img_to_s3(params)
    s3 = Aws::S3Adapter.new
    target_bucket = ENV['S3_PUTBUCKET']
    filename = SecureRandom.uuid + ".jpg"
    img_src = params[:img_src]
    content_type, b64img = img_src.match(/data:(.*?);(?:.*?),(.*)$/).captures
    img = file_decoded_from(b64img);
    # tmpに画像を一時保存
    File.open("tmp/storage/#{filename}", 'wb') do |f|
      f.write(img.read)
    end
    path = "tmp/storage/#{filename}"
    s3.upload(target_bucket, filename, path) # s3にアップロード
    FileUtils.rm(path) # tmpファイル削除
    filename
  end

  def file_decoded_from(b64img)
    tempfile = Base64.decode64(b64img)
    file = Tempfile.new('img')
    file.binmode
    file << tempfile
    file.rewind
    file
  end

  def search_image_from_collection(collection_id, filename)
    rekog = Aws::RekognitionAdapter.new
    rekog.search_faces_by_image(collection_id, ENV['S3_PUTBUCKET'], filename)
  rescue => e
    {}
  end

  def delete_img_from_s3(bucket, filename)
    s3 = Aws::S3Adapter.new
    s3.delete(bucket, filename)
  end
end
