module ApplicationHelper
  # aria-current for header links; the nav styles key off it.
  def current_page_aria(path)
    home = path == tweets_path && current_page?(root_path)
    current_page?(path) || home ? { current: "page" } : {}
  end
end
