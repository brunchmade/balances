module ApplicationHelper

  def cp(path)
    'current' if current_page?(path)
  end

end
