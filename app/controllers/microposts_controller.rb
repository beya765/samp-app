class MicropostsController < ApplicationController
  # L13.34: Micropostsコントローラの各アクションに認可を追加する
  # logged_in_userメソッドはApplicationコントローラー内で定義
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,    only: :destroy #L L13.52

  # L13.36
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # L13.50: createアクションに空の@feed_itemsインスタンス変数を追加する
      @feed_items = []
      render 'static_pages/home'
    end
  end

  # L13.52
  def destroy
    @micropost.destroy # correct_userで渡ってきたマイクロポスト
    flash[:success] = "Micropost deleted"
    # request_referrerメソッド: フレンドリーフォワーディングと似た機能で
    # 一つ前のURLを返す。テストではnilが返ることもあるのでroot_urlも設定
    redirect_to request.referrer || root_url
    # redirect_back(fallback_location: root_url) # こちらでも同じ動作(Rails5から)
  end

  private
    # L13.36: Strong Parametersでパラメータ指定
    # L13.61: pictureを許可された属性のリストに追加する
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # 13.52
    def correct_user
      # 関連付けを使ってマイクロポストを見つけると同時に、他ユーザーからの削除を防いでくれる
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
