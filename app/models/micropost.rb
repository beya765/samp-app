class Micropost < ApplicationRecord
  # L13.2: belongs_toはrails gのuser:references引数により生成
  # belongs_to と has_many の関連付けによって使えるメソッド一覧: (https://railstutorial.jp/chapters/user_microposts?version=5.1#table-association_methods)
  belongs_to :user # L13.10: マイクロポストがユーザーに所属する(belongs_to)関連付け
  # L13.17: default_scopeでマイクロポストを順序付ける
  default_scope -> { order(created_at: :desc) }
  # L13.59: Micropostモデルに画像を追加する(CarrierWaveに画像と関連付けたMicropostモデルを伝える)
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true # L13.5
  validates :content, presence: true, length: { maximum: 140 } # L13.8
  # L13.65: 画像に対するバリデーションを追加する
  validate :picture_size # 独自のバリデーション(validatesではなく、validateメソッドを使っている)

  private
    # L13.65: アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes 
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
