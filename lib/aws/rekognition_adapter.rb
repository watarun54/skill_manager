class Aws::RekognitionAdapter
  def initialize()
    @client = Aws::Rekognition::Client.new(region: Aws.config[:region], credentials: Aws.config[:credentials])
  end

  # コレクション一覧を取得
  def get_collections
    @client.list_collections
  end

  # コレクションを定義
  def describe_collection(collection_id)
    @client.describe_collection({
      collection_id: collection_id,
    })
  end

  # コレクションを削除
  def delete_collection(collection_id)
    @client.delete_collection({
      collection_id: collection_id, 
    })
  end

  # コレクションに顔画像を追加
  def add_face_to_collection(user_id, c_id, s3_bucket, filename)
    res = @client.index_faces({
      collection_id: c_id, 
      detection_attributes: [
      ], 
      external_image_id: user_id.to_s, 
      image: {
        s3_object: {
          bucket: s3_bucket, 
          name: filename, 
        }, 
      }, 
    })
    face_id = res.face_records[0].face.face_id
    User.find(user_id).create_face_image(filename: filename, face_id: face_id)
    res
  end

  # コレクションから顔画像を削除
  def delete_face_from_collection(c_id, face_id)
    @client.delete_faces({
      collection_id: c_id,
      face_ids: [face_id],
    })
  end

  # コレクション内の顔画像一覧
  def get_faces(c_id)
    @client.list_faces({
      collection_id: c_id, 
    })
  end

  # コレクションの中から一致する顔画像を検索
  def search_faces_by_image(c_id, s3_bucket, filename)
    @client.search_faces_by_image({
      collection_id: c_id, 
      face_match_threshold: 99, 
      image: {
        s3_object: {
          bucket: s3_bucket, 
          name: filename, 
        }, 
      }, 
      max_faces: 1, 
    })
  end
end
