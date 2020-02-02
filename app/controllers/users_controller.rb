class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :redirect_login_user, only: [:new, :create]
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @user.email.downcase!

    if @user.save
      flash[:notice] = "Account created successfully!"
      redirect_to login_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Account updated successfully!"
      redirect_to edit_user_path(@user.id)
    else
      render "edit"
    end
  end

  def destroy
    delete_face_img(@current_user, "face-images", ENV['S3_SEARCHBUCKET']) if @current_user.face_image.present?
    if @user.destroy
      flash[:notice] = "Account deleted successfully!"
      redirect_to login_path
    else
      render "edit"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :line_user_id)
  end

  def delete_face_img(user, c_id, bucket)
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
end
