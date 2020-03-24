Rails.application.routes.draw do
  root 'static_pages#home'  
  # リスト3.7：3.6のコマンドでhomeとhelpのアクションルールを定義
  get 'static_pages/home' #/static_pages/homeというURL
  get 'static_pages/help' #/static_pages/helpというURL
  get 'static_pages/about' #/static_pages/aboutというURL
  get 'static_pages/contact'
end
