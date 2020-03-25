module ApplicationHelper
  # L4.2: ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    # 引数で渡ってきた文字列が空のままなら、base_titleだけを使用
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
