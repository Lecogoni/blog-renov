module ApplicationHelper

  def bootstrap_class_for_flash(type)
    case type
      when 'notice' then "alert-primary"
      when 'success' then "alert-success"
      when 'error' then "alert-danger"
      when 'alert' then "alert-warning"
    end
  end

  def device
    agent = request.user_agent
    return "tablet" if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    return "mobile" if agent =~ /Mobile/
    return "desktop"
  end

end
