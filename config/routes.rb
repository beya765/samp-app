Rails.application.routes.draw do
  # root_path('/'), root_url('http://www.example.com/')の文字列を返すメソッドが使える。
  # 基本的には_path書式を、リダイレクト時に_urlを使う。
  root 'static_pages#home'  
  # L3.7：3.6のコマンドでhelpのアクションルールを定義
  # get 'static_pages/help' #/static_pages/helpというURL
  # L5.27: 
  get '/help', to: 'static_pages#help' # /helpアクセス時の該当アクションと名前付きルートの使用
  get '/about', to: 'static_pages#about' # /aboutアクセス時の該当アクションと名前付きルートの使用
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  # L8.2:
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  # L7.3: Usersリソースを追加(https://railstutorial.jp/chapters/sign_up?version=5.1#sec-a_users_resource)
  resources :users
end
