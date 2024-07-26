module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'blue'
    when 'alert' then 'red'
    else 'gray'
    end
  end
end
