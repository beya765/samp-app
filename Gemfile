source 'https://rubygems.org'

gem 'rails',        '5.1.6'
# L5.5: https://railstutorial.jp/chapters/filling_in_the_layout?version=5.1#sec-custom_css
gem 'bootstrap-sass', '3.3.7' 
# L6.36: パスワードを適切にハッシュ化
gem 'bcrypt',         '3.1.12'
# L10.42: 実際にいそうなユーザー名を作成する
# (本来は開発環境以外では使わないが、今回は本番環境でも適用)
gem 'faker',        '1.7.3'
# L13.58: GemfileにCarrierWaveを追加する
gem 'carrierwave',             '1.2.2' # 画像アップローダー
gem 'mini_magick',             '4.7.0' # 画像リサイズ
# L10.44 ページネーション
gem 'will_paginate',           '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'rails_12factor', group: :production
gem 'puma',         '3.9.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug',  '9.0.6', platform: :mri
end

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest',                 '5.10.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg', '0.20.0'
  gem 'fog', '1.42' # L13.58: 本番環境で画像をアップロード
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]